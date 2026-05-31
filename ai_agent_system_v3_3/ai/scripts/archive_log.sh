#!/bin/bash
# archive_log.sh — v3.0  (Mac / Linux)
# 사용법: bash ai/scripts/archive_log.sh
#
# 동작:
#   1. WORK_LOG.md 크기 확인 (50KB 초과 시 아카이브)
#   2. 현재 로그 → .ai_checkpoints/archive/WORK_LOG_YYYYMMDD.md 이동
#   3. 새 WORK_LOG.md 시작 (이전 로그 링크 포함)
#   4. 강제 실행: bash archive_log.sh --force

set -e

LOG_FILE=".ai_checkpoints/WORK_LOG.md"
ARCHIVE_DIR=".ai_checkpoints/archive"
THRESHOLD=51200   # 50KB (bytes)
FORCE=false

if [ "$1" = "--force" ]; then
  FORCE=true
fi

# ── 로그 파일 존재 확인 ───────────────────────────
if [ ! -f "${LOG_FILE}" ]; then
  echo "[INFO] WORK_LOG.md 없음. 아카이브 불필요."
  exit 0
fi

# ── 크기 확인 ─────────────────────────────────────
FILE_SIZE=$(wc -c < "${LOG_FILE}")

if [ "${FORCE}" = "false" ] && [ "${FILE_SIZE}" -lt "${THRESHOLD}" ]; then
  echo "[INFO] WORK_LOG.md 크기: ${FILE_SIZE} bytes (임계값 ${THRESHOLD} bytes 미만)"
  echo "       아카이브 불필요. 강제 실행: bash archive_log.sh --force"
  exit 0
fi

# ── 아카이브 폴더 생성 ────────────────────────────
mkdir -p "${ARCHIVE_DIR}"

# ── 아카이브 파일명 생성 ──────────────────────────
DATE=$(date +"%Y%m%d")
ARCHIVE_FILE="${ARCHIVE_DIR}/WORK_LOG_${DATE}.md"

# 같은 날 이미 아카이브가 있으면 번호 붙이기
if [ -f "${ARCHIVE_FILE}" ]; then
  COUNT=1
  while [ -f "${ARCHIVE_DIR}/WORK_LOG_${DATE}_${COUNT}.md" ]; do
    COUNT=$((COUNT + 1))
  done
  ARCHIVE_FILE="${ARCHIVE_DIR}/WORK_LOG_${DATE}_${COUNT}.md"
fi

# ── 아카이브 실행 ─────────────────────────────────
cp "${LOG_FILE}" "${ARCHIVE_FILE}"
echo "[ARCHIVE] ${LOG_FILE} → ${ARCHIVE_FILE}"

# ── 새 WORK_LOG.md 시작 ───────────────────────────
cat > "${LOG_FILE}" << EOF
# WORK_LOG.md — v3.0
# 시작일: $(date +"%Y-%m-%d")
# 이전 로그: ${ARCHIVE_FILE}

---
EOF

echo "[OK] 새 WORK_LOG.md 시작"
echo "     이전 로그 보존: ${ARCHIVE_FILE}"
echo "     크기: ${FILE_SIZE} bytes → 초기화 완료"
