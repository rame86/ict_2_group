<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>급여 정정</title>
<jsp:include page="../common/header.jsp" />

<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css"
	rel="stylesheet">

<!-- ✅ adminEdit 전용 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/salAdminEdit.css">
</head>

<body>
	<div class="sal-admin-edit">
		<div id="layoutSidenav">
			<jsp:include page="../common/sidebar.jsp" />

			<div id="layoutSidenav_content">
				<main>
					<div class="container-fluid px-4">

						<!-- 헤더 -->
						<div class="edit-header">
							<div>
							<div class="page-title-wrap">
								<h3 class="edit-title">급여 정정</h3>
								</div>
								<p class="edit-sub">수정 내역은 이력으로 저장되며, 정정 사유는 필수입니다.</p>
							</div>
							<div class="edit-header-actions">
								<a class="btn-line"
									href="${pageContext.request.contextPath}/sal/admin/list">목록으로</a>
							</div>
						</div>

						<!-- 상단 요약 카드 -->
						<div class="edit-top-card">
							<div class="top-row">
								<span class="pill">${sal.yearMonthLabel}</span> <span
									class="top-meta"> 사번 <b>${sal.empNo}</b> · 이름 <b>${sal.empName}</b>
									· 부서 <b>${sal.deptName}</b>
								</span>
							</div>
						</div>

						<form method="post"
							action="${pageContext.request.contextPath}/sal/admin/edit"
							class="edit-form">
							<input type="hidden" name="salNum" value="${sal.salNum}" />

							<div class="grid-2">
								<!-- 지급 카드 -->
								<section class="card">
									<div class="card-head">
										<h5>지급 내역</h5>
										<span class="badge">원 단위</span>
									</div>

									<div class="field">
										<label>기본급</label>
										<div class="input-wrap">
											<input type="number" name="salBase" value="${sal.salBase}"
												class="input" required min="0" step="1"> <span
												class="unit">원</span>
										</div>
									</div>

									<div class="field">
										<label>성과금</label>
										<div class="input-wrap">
											<input type="number" name="salBonus" value="${sal.salBonus}"
												class="input" required min="0" step="1"> <span
												class="unit">원</span>
										</div>
									</div>

									<div class="field">
										<label>기타수당</label>
										<div class="input-wrap">
											<input type="number" name="salPlus" value="${sal.salPlus}"
												class="input" required min="0" step="1"> <span
												class="unit">원</span>
										</div>
									</div>

									<div class="field">
										<label>초과근무수당</label>
										<div class="input-wrap">
											<input type="number" name="overtimePay"
												value="${sal.overtimePay == null ? 0 : sal.overtimePay}"
												class="input" required min="0" step="1"> <span
												class="unit">원</span>
										</div>
									</div>
								</section>

								<!-- 공제 카드 -->
								<section class="card">
									<div class="card-head">
										<h5>공제 내역</h5>
										<span class="badge badge-deduct">원 단위</span>
									</div>

									<div class="field">
										<label>보험(공제)</label>
										<div class="input-wrap">
											<input type="number" name="insurance"
												value="${sal.insurance}" class="input" required min="0"
												step="1"> <span class="unit">원</span>
										</div>
									</div>

									<div class="field">
										<label>세금(공제)</label>
										<div class="input-wrap">
											<input type="number" name="tax" value="${sal.tax}"
												class="input" required min="0" step="1"> <span
												class="unit">원</span>
										</div>
									</div>

									<div class="hint-box">
										<b>Tip</b>
										<div class="hint-text">정정 사유는 감사/추적 목적이라 최대한 구체적으로
											남겨주세요.</div>
									</div>
								</section>
							</div>

							<!-- 사유 -->
							<section class="card card-wide">
								<div class="card-head">
									<h5>
										정정 사유 <span class="req">(필수)</span>
									</h5>
								</div>
								<textarea name="editReason" class="textarea" rows="4" required
									maxlength="500" placeholder="예) 초과근무 수당 누락 / 성과금 반영 / 공제 재산정"></textarea>

								<div class="text-counter">
									<span id="reasonCount">0</span><span class="slash">/</span>500
								</div>

							</section>

							<!-- 버튼 -->
							<div class="edit-actions">
								<a class="btn-gray"
									href="${pageContext.request.contextPath}/sal/admin/list">취소</a>
								<button type="submit" class="btn-primary"> 저장</button>
							</div>

							<!-- ✅ 변경 전/후 미리보기 -->
							<section class="card card-wide preview-card"
								data-before-pay="${sal.payTotal == null ? 0 : sal.payTotal}"
								data-before-deduct="${sal.deductTotal == null ? 0 : sal.deductTotal}"
								data-before-real="${sal.realPay == null ? 0 : sal.realPay}">
								<div class="card-head">
									<h5>정정 미리보기</h5>
									<span class="badge">저장 전 화면 계산</span>
								</div>

								<div class="preview-grid">
									<div class="preview-item">
										<div class="lbl">변경 전 실지급액</div>
										<div class="val" id="beforeRealText">-</div>
									</div>

									<div class="preview-item">
										<div class="lbl">변경 후 예상 실지급액</div>
										<div class="val strong" id="afterRealText">-</div>
									</div>

									<div class="preview-item">
										<div class="lbl">차액</div>
										<div class="val" id="diffText">-</div>
										<div class="sub" id="diffHint"></div>
									</div>
								</div>

								<div class="preview-detail">
									<div class="mini">
										<span class="k">예상 총 지급</span> <span class="v"
											id="afterPayText">-</span>
									</div>
									<div class="mini">
										<span class="k">예상 공제 합계</span> <span class="v"
											id="afterDeductText">-</span>
									</div>
								</div>
							</section>


						</form>
					</div>
				</main>

				<jsp:include page="../common/footer.jsp" />
			</div>
		</div>
	</div>
	<script>
(function () {
  const qs = (s) => document.querySelector(s);

  function num(v) {
    const x = Number(String(v ?? "").replace(/,/g, ""));
    return Number.isFinite(x) ? x : 0;
  }
  function won(x) {
    return num(x).toLocaleString("ko-KR") + "원";
  }

  function calc() {
    const base  = num(qs("input[name='salBase']")?.value);
    const bonus = num(qs("input[name='salBonus']")?.value);
    const plus  = num(qs("input[name='salPlus']")?.value);
    const ot    = num(qs("input[name='overtimePay']")?.value);

    const ins = num(qs("input[name='insurance']")?.value);
    const tax = num(qs("input[name='tax']")?.value);

    const afterPay    = base + bonus + plus + ot;
    const afterDeduct = ins + tax;
    const afterReal   = afterPay - afterDeduct;

    const card = qs(".preview-card");
    const beforeReal = num(card?.dataset.beforeReal);

    qs("#beforeRealText").textContent  = won(beforeReal);
    qs("#afterPayText").textContent    = won(afterPay);
    qs("#afterDeductText").textContent = won(afterDeduct);
    qs("#afterRealText").textContent   = won(afterReal);

    const diff = afterReal - beforeReal;
    const diffEl = qs("#diffText");
    const hintEl = qs("#diffHint");

    diffEl.classList.remove("up", "down", "same");

    if (diff > 0) {
      diffEl.classList.add("up");
      diffEl.textContent = "▲ " + won(diff);
      hintEl.textContent = "실지급액이 증가합니다.";
    } else if (diff < 0) {
      diffEl.classList.add("down");
      diffEl.textContent = "▼ " + won(Math.abs(diff));
      hintEl.textContent = "실지급액이 감소합니다.";
    } else {
      diffEl.classList.add("same");
      diffEl.textContent = won(0);
      hintEl.textContent = "실지급액 변동이 없습니다.";
    }
  }

  function updateReasonCount() {
    const ta = qs("textarea[name='editReason']");
    const out = qs("#reasonCount");
    const wrap = qs(".text-counter");
    if (!ta || !out || !wrap) return;

    const max = Number(ta.getAttribute("maxlength") || 500);
    const len = (ta.value || "").length;

    out.textContent = len;
    wrap.classList.toggle("is-max", len >= max);
  }

  document.addEventListener("DOMContentLoaded", function () {
    const form = qs("form.edit-form") || qs("form");
    if (!form) return;

    // 입력/변경 시 미리보기 계산
    form.addEventListener("input", function (e) {
      calc();
      if (e.target && e.target.name === "editReason") updateReasonCount();
    });
    form.addEventListener("change", calc);

    // 저장 전 확인
    form.addEventListener("submit", function (e) {
      const ok = confirm("급여 정정을 저장하시겠습니까?\n저장 시 정정 이력이 남습니다.");
      if (!ok) e.preventDefault();
    });

    // 최초 1회 렌더
    calc();
    updateReasonCount();
  });
})();
</script>
	


</body>
</html>
