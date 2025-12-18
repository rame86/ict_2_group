<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    request.setAttribute("menu", "create");
    // 오늘 날짜 계산 (기안일 기본값용)
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String today = sdf.format(new Date());
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>approve - createForm</title>
<link href="https://cdn.jsdelivr.net/npm/suit-font/dist/suit.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/all.min.css">
<style>
    body { font-family: 'SUIT', sans-serif; background-color: #f8f9fc; }
    
    .unified-card {
        border-radius: 12px;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(33, 40, 50, 0.08);
        background-color: #fff;
        border : 1px solid rgba(0, 0, 0, 0.17);
    }
    
    .unified-card-header {
        padding: 1rem 1.5rem;
        background-color: #92A8D1;
        border-bottom: 1px solid #f1f4f8;
        font-weight: 700;
        color: #FFFFFF;
        border-radius: 12px 12px 0 0;
    }

    .form-group-row {
        display: flex;
        align-items: center;
        margin-bottom: 1.2rem;
        width: 100%; /* 너비 전체 사용 */
    }

    /* ✅ 한 줄에 두 항목을 넣기 위한 스타일 추가 */
    .info-item {
        display: flex;
        align-items: center;
        flex: 1; /* 가로 너비 반분 */
    }

    .label-box {
        width: 130px;
        font-size: 0.9rem;
        font-weight: 700;
        color: #4a5568;
        flex-shrink: 0;
    }
    .input-box { flex: 1; position: relative; }

    .input-custom {
        width: 100%;
        padding: 0.6rem 1rem;
        font-size: 0.9rem;
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        background-color: #fff;
        transition: 0.2s;
        color: #333;
    }
    .input-custom:focus {
        border-color: #4e73df;
        outline: none;
        box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.1);
    }
    .input-custom[readonly] {
        background-color: #f8f9fc;
        border-color: #e2e8f0;
        color: #718096;
    }

    .textarea-custom {
        width: 100%;
        min-height: 250px;
        padding: 1.2rem;
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        resize: none;
        font-size: 0.95rem;
        line-height: 1.6;
        transition: 0.2s;
        outline: none;
    }
    .textarea-custom:focus {
        border-color: #4e73df;
        box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.1);
    }

    .file-upload-wrapper { display: flex; align-items: center; gap: 8px; }
    .file-select-btn {
        padding: 0.6rem 1rem;
        font-size: 0.9rem;
        font-weight: 600;
        color: #4a5568;
        background-color: #f8f9fc;
        border: 1px solid #d1d9e6;
        border-radius: 8px;
        cursor: pointer;
        white-space: nowrap;
        transition: 0.2s;
    }

    .doc-type-card-header {
        padding: 1rem 1.5rem;
        background-color: #92A8D1;
        border-bottom: 1px solid #f1f4f8;
        font-weight: 700;
        color: #FFFFFF;
        border-radius: 12px 12px 0 0;
    }
    
    .doc-type-list .list-group-item {
        border: none;
        padding: 0.9rem 1.25rem;
        font-size: 0.9rem;
        color: #4a5568;
        cursor: pointer;
        border-radius: 8px !important;
        margin-bottom: 4px;
        transition: 0.2s;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .doc-type-list .list-group-item.active {
        background-color: #4e73df !important;
        color: white !important;
        font-weight: 700;
    }

    .form-footer-btns {
        display: flex;
        justify-content: center;
        gap: 12px;
        margin-top: 2rem;
        padding-top: 1.5rem;
        border-top: 1px solid #f1f4f8;
    }
    
    .btn-reset-custom {
        background-color: #fff;
        border: 1px solid #d1d5db;
        color: #4b5563;
        padding: 0.6rem 2.5rem;
        font-size: 0.9rem;
        font-weight: 600;
        border-radius: 8px;
        transition: 0.2s;
    }
    
    .btn-submit-custom {
        background-color: #4e73df;
        border: 1px solid #4e73df;
        color: #fff;
        padding: 0.6rem 3.5rem;
        font-size: 0.9rem;
        font-weight: 700;
        border-radius: 8px;
        box-shadow: 0 4px 6px -1px rgba(78, 115, 223, 0.2);
        transition: 0.2s;
    }
</style>
</head>
<body class="sb-nav-fixed">

    <jsp:include page="../common/header.jsp" flush="true"/>
    
    <div id="layoutSidenav">
        <jsp:include page="../common/sidebar.jsp" flush="true"/>
        
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h3 class="mt-4">문서 작성 하기</h3><br>
                    
                    <div class="row">
                        <div class="col-xl-3 col-lg-4 mb-4">
                            <div class="unified-card">
                                <div class="doc-type-card-header">
                                    <i class="fas fa-folder-open me-2"></i>문서 종류
                                </div>
                                <div class="card-body p-3">
                                    <div class="list-group doc-type-list">
                                        <button type="button" class="list-group-item list-group-item-action active document-type-btn" data-doc-type="1" data-doc-name="품의서"><i class="fas fa-file-signature"></i>품의서</button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="2" data-doc-name="기획서"><i class="fas fa-lightbulb"></i>기획서</button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="3" data-doc-name="제안서"><i class="fas fa-chart-line"></i>제안서</button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="4" data-doc-name="연차 신청서"><i class="fas fa-umbrella-beach"></i>연차 신청</button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="5" data-doc-name="오전 반차 신청서"><i class="fas fa-sun"></i>오전 반차</button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="6" data-doc-name="오후 반차 신청서"><i class="fas fa-moon"></i>오후 반차</button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="7" data-doc-name="병가 신청서"><i class="fas fa-notes-medical"></i>병가 신청</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-9 col-lg-8">
                            <div class="unified-card">
                                <div class="unified-card-header" id="selectedDocTitle">신규 품의서 작성</div>
                                <div class="card-body p-4">
                                    <form action="approve-form" method="POST" id="documentForm" enctype="multipart/form-data">
                                        <input type="hidden" name="DocType" id="documentTypeInput" value="1">
                                        <input type="hidden" name="empNo" value="${ sessionScope.login.empNo }">
                                        <input type="hidden" name="gradeNo" value="${ sessionScope.login.gradeNo }">
                                        <input type="hidden" name="step1ManagerNo" value="${ loginVO.managerEmpNo }">
                                        <input type="hidden" name="step2ManagerNo" value="${ loginVO.parentDeptNo }">

                                        <div class="form-group-row">
                                            <div class="label-box">문서 제목</div>
                                            <div class="input-box"><input class="input-custom" id="documentTitle" name="docTitle" type="text" placeholder="제목을 입력해 주세요" required></div>
                                        </div>

                                        <div class="form-group-row">
                                            <div class="info-item">
                                                <div class="label-box">기안일</div>
                                                <div class="input-box"><input type="date" class="input-custom" id="draftDate" name="docDate" value="<%= today %>" required></div>
                                            </div>
                                            <div class="info-item ms-4"> <div class="label-box">기안자</div>
                                                <div class="input-box"><input type="text" class="input-custom" name="empName" value="${ sessionScope.login.empName }" readonly></div>
                                            </div>
                                        </div>

                                        <div class="form-group-row">
                                            <div class="label-box">결재자</div>
                                            <div class="input-box d-flex gap-3">
                                                <input type="text" class="input-custom" value="1차: ${ loginVO.managerName }" readonly placeholder="결재자 1">
                                                <input type="text" class="input-custom" value="2차: ${ loginVO.parentDeptName }" readonly placeholder="결재자 2">
                                            </div>
                                        </div>

                                        <div class="form-group-row">
                                            <div class="label-box">첨부 파일</div>
                                            <div class="input-box">
                                                <div class="file-upload-wrapper">
                                                    <input type="text" class="input-custom" id="fileNameDisplay" placeholder="선택된 파일 없음" readonly style="background-color: #fff;">
                                                    <label for="realFileInput" class="file-select-btn"><i class="fas fa-upload me-1"></i> 파일 선택</label>
                                                    <input type="file" name="upfile" id="realFileInput" style="display: none;">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mt-4" id="templateArea">
                                            <div id="template1" class="doc-template"><textarea class="textarea-custom" name="docContent" required placeholder="품의서 내용을 입력하세요."></textarea></div>
                                            <div id="template2" class="doc-template d-none"><textarea class="textarea-custom" name="docContent" placeholder="기획 목적, 배경 등을 작성하세요."></textarea></div>
                                            <div id="template3" class="doc-template d-none"><textarea class="textarea-custom" name="docContent" placeholder="제안할 사항을 상세히 입력하세요."></textarea></div>
                                            <div id="template4" class="doc-template d-none"><textarea class="textarea-custom" name="docContent" placeholder="연차 신청 사유 및 기간을 입력하세요."></textarea></div>
                                            <div id="template5" class="doc-template d-none"><textarea class="textarea-custom" name="docContent" placeholder="오전 반차 사유를 입력하세요."></textarea></div>
                                            <div id="template6" class="doc-template d-none"><textarea class="textarea-custom" name="docContent" placeholder="오후 반차 사유를 입력하세요."></textarea></div>
                                            <div id="template7" class="doc-template d-none"><textarea class="textarea-custom" name="docContent" placeholder="병가 사유 및 증빙 계획을 입력하세요."></textarea></div>
                                        </div>

                                        <div class="form-footer-btns">
                                            <button type="reset" class="btn-reset-custom">초기화</button>
                                            <button type="submit" class="btn-submit-custom">문서 제출</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../common/footer.jsp" flush="true"/>
        </div>
    </div>

    <script>
    document.addEventListener("DOMContentLoaded", () => {
        const buttons = document.querySelectorAll(".document-type-btn");
        const hiddenDocType = document.getElementById("documentTypeInput");
        const templates = document.querySelectorAll(".doc-template");
        const cardTitle = document.getElementById("selectedDocTitle");

        buttons.forEach(btn => {
            btn.addEventListener("click", () => {
                buttons.forEach(b => b.classList.remove("active"));
                btn.classList.add("active");
                const docType = btn.dataset.docType;
                const docName = btn.dataset.docName;
                
                hiddenDocType.value = docType;
                cardTitle.innerText = "신규 " + docName + " 작성";
                
                templates.forEach(tpl => {
                    tpl.classList.add("d-none");
                    const textarea = tpl.querySelector("textarea");
                    if(textarea) textarea.removeAttribute("required");
                });
                
                const selectedTemplate = document.getElementById("template" + docType);
                if(selectedTemplate) {
                    selectedTemplate.classList.remove("d-none");
                    const selectedTextarea = selectedTemplate.querySelector("textarea");
                    if(selectedTextarea) selectedTextarea.setAttribute("required", "required");
                }
            });
        });

        document.getElementById("realFileInput").addEventListener("change", function() {
            if (this.files && this.files.length > 0) {
                document.getElementById("fileNameDisplay").value = this.files[0].name;
            } else {
                document.getElementById("fileNameDisplay").value = "";
            }
        });
    });
    </script>
</body>
</html>