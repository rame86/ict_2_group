<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("menu", "create");
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
    
    /* 카드 디자인 */
    .unified-card {
        border: none;
        border-radius: 12px;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(33, 40, 50, 0.08);
        background-color: #fff;
        border : 1px solid rgba(0, 0, 0, 0.17);
    }
    
    /* 헤더 스타일 변경 (요청하신 색상 적용) */
    .unified-card-header {
        padding: 1rem 1.5rem;
        background-color: #92A8D1;
        border-bottom: 1px solid #f1f4f8;
        font-weight: 700;
        color: #FFFFFF;
        border-radius: 12px 12px 0 0;
    }

    /* 수평 레이아웃 설정 */
    .form-group-row {
        display: flex;
        align-items: center;
        margin-bottom: 1.2rem;
    }
    .label-box {
        width: 130px;
        font-size: 0.9rem; /* 글자 크기 유지 */
        font-weight: 700;
        color: #4a5568;
        flex-shrink: 0;
    }
    .input-box {
        flex: 1;
        position: relative;
    }

    /* 인풋/텍스트박스 스타일 */
    .input-custom {
        width: 100%;
        padding: 0.6rem 1rem;
        font-size: 0.9rem; /* 글자 크기 유지 */
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

    /* 텍스트에어리어 스타일 */
    .textarea-custom {
        width: 100%;
        min-height: 400px;
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

    /* 파일 업로드 커스텀 스타일 */
    .file-upload-wrapper {
        display: flex;
        align-items: center;
        gap: 8px;
    }
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
    .file-select-btn:hover {
        background-color: #edf2f7;
        border-color: #cbd5e0;
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
    .doc-type-list .list-group-item i {
        width: 20px;
        text-align: center;
        color: #a0aec0;
    }
    /* 활성화 상태 색상은 유지 (파란색 포인트) */
    .doc-type-list .list-group-item.active {
        background-color: #4e73df !important;
        color: white !important;
        font-weight: 700;
    }
    .doc-type-list .list-group-item.active i {
        color: white;
    }

    /* 하단 버튼 영역 */
    .form-footer-btns {
        display: flex;
        justify-content: flex-end;
        gap: 8px;
        margin-top: 1.5rem;
        padding-top: 1rem;
        border-top: 1px solid #f1f4f8;
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
                    <h3 class="mt-4 fw-bold" style="font-size: 1.5rem;">문서 작성 하기</h3><br>
                    
                    <div class="row">
                        <div class="col-xl-3 col-lg-4 mb-4">
                            <div class="unified-card">
                                <div class="doc-type-card-header">
                                    <i class="fas fa-folder-open me-2"></i>문서 종류
                                </div>
                                <div class="card-body p-3">
                                    <div class="list-group doc-type-list">
                                        <button type="button" class="list-group-item list-group-item-action active document-type-btn" data-doc-type="1" data-doc-name="품의서">
                                            <i class="fas fa-file-signature"></i>품의서
                                        </button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="2" data-doc-name="기획서">
                                            <i class="fas fa-lightbulb"></i>기획서
                                        </button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="3" data-doc-name="보고서">
                                            <i class="fas fa-chart-line"></i>보고서
                                        </button>
                                        
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="4" data-doc-name="연차 신청서">
                                            <i class="fas fa-umbrella-beach"></i>연차 신청
                                        </button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="5" data-doc-name="오전 반차 신청서">
                                            <i class="fas fa-sun"></i>오전 반차
                                        </button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="6" data-doc-name="오후 반차 신청서">
                                            <i class="fas fa-moon"></i>오후 반차
                                        </button>
                                        <button type="button" class="list-group-item list-group-item-action document-type-btn" data-doc-type="7" data-doc-name="병가 신청서">
                                            <i class="fas fa-notes-medical"></i>병가 신청
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-9 col-lg-8">
                            <div class="unified-card">
                                <div class="unified-card-header" id="selectedDocTitle">신규 품의서 작성</div>
                                <div class="card-body p-4">
                                    <form action="insertDocument" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="documentType" id="documentTypeInput" value="1">

                                        <div class="form-group-row">
                                            <div class="label-box">문서 제목</div>
                                            <div class="input-box">
                                                <input class="input-custom" name="docTitle" type="text" placeholder="제목을 입력해 주세요" required>
                                            </div>
                                        </div>

                                        <div class="form-group-row">
                                            <div class="label-box">첨부 파일</div>
                                            <div class="input-box">
                                                <div class="file-upload-wrapper">
                                                    <input type="text" class="input-custom" id="fileNameDisplay" placeholder="선택된 파일 없음" readonly style="background-color: #fff; cursor: default;">
                                                    
                                                    <label for="realFileInput" class="file-select-btn">
                                                        <i class="fas fa-upload me-1"></i> 파일 선택
                                                    </label>
                                                    
                                                    <input type="file" name="upfile" id="realFileInput" style="display: none;">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group-row">
                                            <div class="label-box">결재자 지정</div>
                                            <div class="input-box d-flex gap-3">
                                                <input type="text" class="input-custom" value="1차: 차장 김철수" readonly>
                                                <input type="text" class="input-custom" value="2차: 부장 이영희" readonly>
                                                <input type="hidden" name="step1ManagerNo" value="101">
                                                <input type="hidden" name="step2ManagerNo" value="102">
                                            </div>
                                        </div>

                                        <div class="mt-4">
                                            <div id="template1" class="doc-template">
                                                <textarea class="textarea-custom" name="docContent" required>[품의 목적]&#10;- &#10;&#10;[세부 내용]&#10;- </textarea>
                                            </div>
                                            <div id="template2" class="doc-template d-none">
                                                <textarea class="textarea-custom" name="docContent">[기획 배경]&#10;- </textarea>
                                            </div>
                                            <div id="template3" class="doc-template d-none">
                                                <textarea class="textarea-custom" name="docContent">[보고 내용]&#10;- </textarea>
                                            </div>
                                            
                                            <div id="template4" class="doc-template d-none">
                                                <textarea class="textarea-custom" name="docContent">[연차 사유]&#10;- &#10;&#10;[비상 연락망]&#10;- </textarea>
                                            </div>
                                            <div id="template5" class="doc-template d-none">
                                                <textarea class="textarea-custom" name="docContent">[오전 반차 사유]&#10;- &#10;&#10;[오후 업무 복귀 예정 시간]&#10;- 14:00</textarea>
                                            </div>
                                            <div id="template6" class="doc-template d-none">
                                                <textarea class="textarea-custom" name="docContent">[오후 반차 사유]&#10;- &#10;&#10;[퇴근 예정 시간]&#10;- 14:00</textarea>
                                            </div>
                                            <div id="template7" class="doc-template d-none">
                                                <textarea class="textarea-custom" name="docContent">[병가 사유]&#10;- &#10;&#10;[증빙 서류 유무]&#10;- </textarea>
                                            </div>
                                        </div>

                                        <div class="form-footer-btns">
                                            <button type="reset" class="btn btn-light px-4 border" style="font-size: 0.9rem;">초기화</button>
                                            <button type="submit" class="btn btn-primary px-5 fw-bold" style="font-size: 0.9rem;">결재 상신</button>
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
        // 1. 문서 종류 변경 로직
        const buttons = document.querySelectorAll(".document-type-btn");
        const hiddenDocType = document.getElementById("documentTypeInput");
        const templates = document.querySelectorAll(".doc-template");
        const cardTitle = document.getElementById("selectedDocTitle");
        const docContentTextarea = document.querySelector("textarea[name='docContent']"); // 텍스트에어리어

        buttons.forEach(btn => {
            btn.addEventListener("click", () => {
                buttons.forEach(b => b.classList.remove("active"));
                btn.classList.add("active");

                const docType = btn.dataset.docType;
                const docName = btn.dataset.docName;
                hiddenDocType.value = docType;
                cardTitle.innerText = "신규 " + docName + " 작성";

                // 모든 템플릿 숨김
                templates.forEach(tpl => {
                    tpl.classList.add("d-none");
                    // 숨겨진 템플릿 안의 textarea는 required 속성 제거 (폼 전송 오류 방지)
                    const textarea = tpl.querySelector("textarea");
                    if(textarea) textarea.removeAttribute("required");
                });
                
                // 선택된 템플릿 보이기
                const selectedTemplate = document.getElementById("template" + docType);
                selectedTemplate.classList.remove("d-none");
                // 선택된 템플릿의 textarea에 required 추가
                const selectedTextarea = selectedTemplate.querySelector("textarea");
                if(selectedTextarea) selectedTextarea.setAttribute("required", "required");
            });
        });

        // 2. 파일 선택 시 파일명 표시 로직
        const realFileInput = document.getElementById("realFileInput");
        const fileNameDisplay = document.getElementById("fileNameDisplay");

        realFileInput.addEventListener("change", function() {
            if (this.files && this.files.length > 0) {
                fileNameDisplay.value = this.files[0].name; // 파일명 표시
            } else {
                fileNameDisplay.value = ""; // 취소 시 초기화
            }
        });
    });
    </script>
</body>
</html>