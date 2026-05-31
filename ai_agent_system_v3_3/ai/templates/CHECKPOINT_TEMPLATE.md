# CHECKPOINT_TEMPLATE.md — v3.0
# 위치: .ai_checkpoints/YYYYMMDD_HHMM/CHECKPOINT.md
# 복사해서 사용. No-Git 환경 전용.

---

## 기본 정보

```
checkpoint_id   : YYYYMMDD_HHMM
created_at      : YYYY-MM-DD HH:MM:SS
agent_version   : v3.0
context_profile : WORK | HOBBY
risk_level      : STANDARD | CRITICAL
task_summary    : {한 줄 요약}
```

## 백업 파일 목록 + 무결성 해시

```
# SHA256 해시는 백업 직후 기록. 롤백 시 복원 후 재확인.
# Mac Terminal / 회사 Git Bash 공통: shasum -a 256 {파일}

backups:
  - original : {원본 파일 경로}
    backup   : .ai_checkpoints/YYYYMMDD_HHMM/{파일명}.bak
    sha256   : {해시값}
    action   : MODIFY | DELETE

new_files_created:
  - {새로 생성된 파일 경로}   # 롤백 시 삭제
```

## 롤백 절차 (No-Git / Git Bash & Mac Terminal 공통)

```bash
# Mac Terminal 또는 회사 Git Bash — 동일한 명령어
cp ".ai_checkpoints/YYYYMMDD_HHMM/{파일명}.bak" "{원본 경로/파일명}"
# 신규 생성 파일 롤백: rm {파일 경로}

# 무결성 재확인
shasum -a 256 {복원된 파일}   # 위 sha256 값과 일치해야 함
```

## 검증 상태

```
status          : PENDING | PASS | FAIL | ROLLED_BACK | ABANDONED
validation_note : {검증 방법 및 결과}
completed_at    : YYYY-MM-DD HH:MM:SS
```

## TTL

```
expires_at           : YYYY-MM-DD   # WORK: +90일, HOBBY: +30일
archive_eligible     : false        # PASS 후 true로 변경
```

---

## 작성 예시

```
checkpoint_id   : 20260530_1430
created_at      : 2026-05-30 14:30:00
agent_version   : v3.0
context_profile : WORK
risk_level      : CRITICAL
task_summary    : config/database.json 연결 풀 10→50 변경

backups:
  - original : config/database.json
    backup   : .ai_checkpoints/20260530_1430/database.json.bak
    sha256   : a3f1c2d4e5b6...
    action   : MODIFY

new_files_created: []

롤백 (Mac Terminal / Git Bash 공통):
  cp ".ai_checkpoints/20260530_1430/database.json.bak" "config/database.json"

무결성 재확인:
  shasum -a 256 config/database.json   →  a3f1c2d4e5b6... 와 일치 확인

status          : PASS
validation_note : python test_db.py → 50 connections OK
completed_at    : 2026-05-30 14:38:00
expires_at      : 2026-08-28
archive_eligible: true
```
