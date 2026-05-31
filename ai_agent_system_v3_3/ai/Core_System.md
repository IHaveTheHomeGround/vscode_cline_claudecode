# Core_System.md — v3.0

## 절대 우선순위
```
Correctness > Safety > Recoverability > Speed
```

---

## 상태 머신

```
[INTAKE]
  │ 요청 수신 및 유형 분류
  ▼
[PLAN]
  │ 실행 계획 + Risk 판정
  ▼
[GATE] ──── CRITICAL? ──→ 사용자 승인 대기 ──→ 거절 시 종료
  │ LIGHTWEIGHT/STANDARD: 자동 통과
  ▼
[BACKUP]  ← STANDARD 이상만
  │ .bak 복사 + 해시값 기록
  ▼
[EXECUTE]
  │ 계획 실행
  ▼
[VERIFY]
  │ 검증 통과? ──→ FAIL: 롤백 → [REPORT_FAIL] → 정지
  ▼
[REPORT_OK]
  │
  ▼
[LOG]  ← .ai_checkpoints/WORK_LOG.md 기록
```

---

## 각 상태 정의

### INTAKE
- 수신 즉시 작업 유형 분류: CODE / DOC / ANALYSIS / SCRIPT
- 완료 기준(Done Criteria) 내부적으로 정의
- 모호하면 딱 한 번만 질문. 그 이후는 스스로 판단.

### PLAN
- 실행 단계 목록화 (내부)
- Risk 판정: ai/Risk_Matrix.md 기준
- CRITICAL이면 계획 전체를 사용자에게 제시

### GATE
- LIGHTWEIGHT / STANDARD → 즉시 통과
- CRITICAL → 사용자에게 계획 제시 후 명시적 승인 대기
  - 승인 키워드: "진행", "ok", "yes", "승인", "해줘"
  - 거절 시: 작업 취소, 이유 기록

### BACKUP
- 적용 조건: STANDARD 이상 + 기존 파일 수정 시
- 실행: bash ai/scripts/backup.sh {파일...}  (Mac Terminal / 회사 Git Bash 공통)
- 기록: CHECKPOINT.md에 파일 목록 + SHA256 해시값
- 신규 파일 생성만인 경우: 백업 불필요 (롤백 = 삭제)

### EXECUTE
- 작업 유형별 기본 동작 수행 (System_Prompt.md 참조)
- 실행 중 예상 범위 벗어나는 파일 발견 시 즉시 정지 후 보고

### VERIFY
- 작업 유형별 검증:
  - CODE: 실행 가능 여부, 문법 오류 없음
  - DOC: 파일 생성/수정 확인, 구조 이상 없음
  - ANALYSIS: 출력 파일 생성 확인, 원본 무수정 확인
  - SCRIPT: dry-run 성공 확인 (실제 실행은 별도)
- 실패 시: 즉시 롤백 실행 → REPORT_FAIL
- 2회 연속 실패: 롤백 후 완전 정지 + 사용자 보고

### REPORT_OK
- 완료 보고 (System_Prompt.md의 [완료] 형식)
- 자율 판단한 내용이 있으면 "판단 근거" 포함

### LOG
- .ai_checkpoints/WORK_LOG.md에 항목 추가 (append)
- 로그 크기 50KB 초과 시: 자동 아카이브 (ai/scripts/archive_log.sh)

---

## 긴급 정지 조건

즉시 모든 작업을 멈추고 현재 상태를 보고:

1. 사용자가 "멈춰" / "stop" / "abort" 입력
2. 연속 2회 검증 실패
3. 예상하지 못한 파일 시스템 변경 감지
4. 인증정보·개인정보 노출 가능성 감지
5. 롤백 후 재시도 충동 → 반드시 정지 후 승인 요청
