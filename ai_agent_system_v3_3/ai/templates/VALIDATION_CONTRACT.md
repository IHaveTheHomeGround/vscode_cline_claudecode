# VALIDATION_CONTRACT.md — v3.0
# STANDARD 이상 작업 전 작성. No-Git 환경 전용.

---

## 계약 정보

```
contract_id  : YYYYMMDD_HHMM_{작업약어}
task         : {수행할 작업 설명}
risk_level   : STANDARD | CRITICAL
task_type    : CODE | DOC | ANALYSIS | SCRIPT
```

## 검증 계약

```
target_files:
  - {대상 파일 1}
  - {대상 파일 2}

expected_result: |
  {완료 후 기대 상태 - 구체적으로}

validation_method: |
  {어떻게 확인할지 - 실행할 명령어 또는 확인 방법}

rollback_condition: |
  - {롤백 실행 조건 1}
  - {롤백 실행 조건 2}

rollback_procedure: |
  Windows:
    copy ".ai_checkpoints\{id}\{파일}.bak" "{원본경로\파일}"
  Mac/Linux:
    cp ".ai_checkpoints/{id}/{파일}.bak" "{원본경로/파일}"
  신규 파일 삭제:
    del {파일}  /  rm {파일}
```

## 승인

```
prepared_by  : agent_v3.0
approved_by  : auto | {사용자}   # CRITICAL은 사용자 승인
approved_at  : YYYY-MM-DD HH:MM:SS
```

---

## 작업 유형별 검증 방법 가이드

> **Mac Terminal / 회사 Git Bash 모두 동일한 명령어를 사용합니다.**

### CODE
```bash
# 문법 확인
python -m py_compile {파일}.py
node --check {파일}.js

# 실행 확인
python {파일}.py
node {파일}.js

# 함수 단위 확인
python -c "from {모듈} import {함수}; print({함수}({인자}))"
```

### DOC
```bash
# 파일 존재 + 내용 미리보기
ls {파일경로}
head -20 {파일}

# 마크다운 헤더 구조 확인
grep "^#" {파일}.md
```

### ANALYSIS
```bash
# 원본 무수정 확인 (해시 비교)
shasum -a 256 {원본파일}   # 작업 전 해시와 일치해야 함

# 결과 파일 생성 확인
ls {결과파일}
wc -l {결과파일}
```

### SCRIPT
```bash
# dry-run 먼저
bash {스크립트}.sh --dry-run

# 종료 코드 확인 (0이면 성공)
echo $?
```

---

## 작성 예시 (CODE / STANDARD)

```
contract_id  : 20260530_1500_add_logger
task         : src/utils/logger.py 신규 생성, main.py의 print() → logger.info() 교체
risk_level   : STANDARD
task_type    : CODE

target_files:
  - src/utils/logger.py (CREATE)
  - src/main.py (MODIFY)

expected_result: |
  - logger.py의 get_logger() 함수가 Logger 인스턴스 반환
  - main.py에 print() 0개 (모두 교체됨)
  - python main.py 실행 정상

validation_method: |
  1. python -c "from src.utils.logger import get_logger; print('OK')"
  2. python main.py  →  오류 없이 완료
  3. grep -c "print(" src/main.py  →  0

rollback_condition: |
  - 위 검증 1, 2, 3 중 하나라도 실패
  - main.py 외 파일이 수정된 경우

rollback_procedure: |
  # Mac Terminal / 회사 Git Bash — 동일한 명령어
  rm src/utils/logger.py
  cp ".ai_checkpoints/20260530_1500/main.py.bak" "src/main.py"

prepared_by  : agent_v3.0
approved_by  : auto
approved_at  : 2026-05-30 15:00:00
```
