# WORK_LOG_TEMPLATE.md — v3.0
# 실제 로그 파일 위치: .ai_checkpoints/WORK_LOG.md
# 세션마다 항목을 아래에 추가 (append)
# 50KB 초과 시 ai/scripts/archive_log.sh 실행하여 아카이브

---

## 로그 항목 형식

```
---
## [YYYYMMDD_HHMM] {작업 제목}
- 상태     : COMPLETED | FAILED | ROLLED_BACK | ABANDONED
- Risk     : LIGHTWEIGHT | STANDARD | CRITICAL
- 유형     : CODE | DOC | ANALYSIS | SCRIPT
- 모드     : WORK | HOBBY
- 소요시간 : {분}분

### 수행 내용
{2~4줄 요약}

### 변경 파일
- {경로} (CREATE | MODIFY | DELETE)

### 검증
- 방법: {사용한 방법}
- 결과: PASS | FAIL | 해당없음

### 체크포인트
- {경로} 또는 "해당없음"

### 메모
{다음에 참고할 사항, 문제점, 발견한 것}
---
```

---

## WORK_LOG.md 파일 구조 예시

```markdown
# WORK_LOG.md — v3.0
# 시작일: 2026-05-30
# 이전 로그: archive/WORK_LOG_20260429.md  ← 아카이브 시 추가

---
## [20260530_1430] database.json 연결 풀 변경

- 상태     : COMPLETED
- Risk     : CRITICAL
- 유형     : CODE
- 모드     : WORK
- 소요시간 : 12분

### 수행 내용
config/database.json의 connection_pool_size를 10 → 50으로 변경.
피크타임 DB 연결 부족 문제 해결.

### 변경 파일
- config/database.json (MODIFY)

### 검증
- 방법: python test_db.py 실행
- 결과: PASS (50 connections established)

### 체크포인트
- .ai_checkpoints/20260530_1430/

### 메모
설정 변경 후 앱 재시작 필요. 다음에는 재시작 절차도 Validation Contract에 포함.

---
## [20260530_1600] logger.py 유틸 추가

- 상태     : COMPLETED
- Risk     : STANDARD
- 유형     : CODE
- 모드     : WORK
- 소요시간 : 20분

### 수행 내용
src/utils/logger.py 신규 생성.
main.py의 print() 3개를 logger.info()로 교체.

### 변경 파일
- src/utils/logger.py (CREATE)
- src/main.py (MODIFY)

### 검증
- 방법: python main.py + grep -c "print(" src/main.py
- 결과: PASS

### 체크포인트
- 해당없음 (STANDARD, 신규+수정 혼합)

### 메모
STANDARD 작업도 기존 파일 수정 시 백업 생성함. CREATE만이면 백업 불필요.

---
```
