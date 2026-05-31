#!/bin/bash
# backup.sh — v3.0  (Mac / Linux)
# 사용법: bash ai/scripts/backup.sh {파일1} {파일2} ...
# 예시  : bash ai/scripts/backup.sh src/main.py config/settings.json
#
# 동작:
#   1. .ai_checkpoints/YYYYMMDD_HHMM/ 폴더 생성
#   2. 지정 파일을 .bak으로 복사
#   3. 각 파일의 SHA256 해시 기록 → CHECKPOINT.md 초안 생성
#   4. 체크포인트 ID 출력 (VALIDATION_CONTRACT 작성에 사용)

set -e

# ── 설정 ──────────────────────────────────────────
CHECKPOINT_DIR=".ai_checkpoints"
TIMESTAMP=$(date +"%Y%m%d_%H%M")
DEST="${CHECKPOINT_DIR}/${TIMESTAMP}"
CHECKPOINT_FILE="${DEST}/CHECKPOINT.md"

# ── 인자 확인 ─────────────────────────────────────
if [ $# -eq 0 ]; then
  echo "[ERROR] 백업할 파일을 지정하세요."
  echo "  사용법: bash ai/scripts/backup.sh {파일1} {파일2} ..."
  exit 1
fi

# ── 폴더 생성 ─────────────────────────────────────
mkdir -p "${DEST}"
echo "[BACKUP] 체크포인트 생성: ${DEST}"

# ── CHECKPOINT.md 헤더 작성 ───────────────────────
cat > "${CHECKPOINT_FILE}" << EOF
# CHECKPOINT.md — v3.0
checkpoint_id   : ${TIMESTAMP}
created_at      : $(date +"%Y-%m-%d %H:%M:%S")
agent_version   : v3.0
status          : PENDING

## 백업 파일 목록
EOF

# ── 파일 백업 + 해시 기록 ─────────────────────────
for SRC in "$@"; do
  if [ ! -f "${SRC}" ]; then
    echo "[WARN] 파일 없음, 건너뜀: ${SRC}"
    continue
  fi

  FILENAME=$(basename "${SRC}")
  BAK_PATH="${DEST}/${FILENAME}.bak"

  cp "${SRC}" "${BAK_PATH}"
  HASH=$(shasum -a 256 "${SRC}" | awk '{print $1}')

  echo "  - original : ${SRC}"      >> "${CHECKPOINT_FILE}"
  echo "    backup   : ${BAK_PATH}" >> "${CHECKPOINT_FILE}"
  echo "    sha256   : ${HASH}"     >> "${CHECKPOINT_FILE}"
  echo "    action   : MODIFY"      >> "${CHECKPOINT_FILE}"
  echo ""                           >> "${CHECKPOINT_FILE}"

  echo "  [OK] ${SRC}"
  echo "       → ${BAK_PATH}"
  echo "       SHA256: ${HASH}"
done

# ── 롤백 절차 추가 ────────────────────────────────
cat >> "${CHECKPOINT_FILE}" << EOF

## 롤백 절차 (Mac/Linux)
EOF

for SRC in "$@"; do
  [ ! -f "${SRC}" ] && continue
  FILENAME=$(basename "${SRC}")
  BAK_PATH="${DEST}/${FILENAME}.bak"
  echo "  cp \"${BAK_PATH}\" \"${SRC}\"" >> "${CHECKPOINT_FILE}"
done

cat >> "${CHECKPOINT_FILE}" << EOF

## 무결성 재확인 (롤백 후)
EOF

for SRC in "$@"; do
  [ ! -f "${SRC}" ] && continue
  echo "  shasum -a 256 \"${SRC}\"  # 위 sha256 값과 일치 확인" >> "${CHECKPOINT_FILE}"
done

cat >> "${CHECKPOINT_FILE}" << EOF

## 검증 상태
status          : PENDING
validation_note :
completed_at    :
EOF

echo ""
echo "[DONE] 체크포인트 ID: ${TIMESTAMP}"
echo "       CHECKPOINT.md: ${CHECKPOINT_FILE}"
echo "       → 이 ID를 VALIDATION_CONTRACT의 rollback_procedure에 사용하세요."
