<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<title>사원 계정 등록</title>
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/member.js"></script>

<style type="text/css">
    /* === [공통] 기본 레이아웃 및 버튼 스타일 === */
    #submitBtn:disabled { opacity: 0.5; cursor: not-allowed; }

    /* 핑크색 버튼 (로그인/회원가입 공통) */
    .btn-primary { 
        background-color: #e85a6a !important; border-color: #e85a6a !important;
        color: #ffffff !important; font-weight: bold;
        padding: 10px 20px; border-radius: 8px; width: 100%; height: 50px;
        transition: all 0.3s;
    }
    .btn-primary:hover {
        background-color: #d14656 !important; border-color: #d14656 !important;
    }

    /* 유효성 검사 텍스트 */
    .valid-feedback { color: #28a745; font-size: 0.85rem; display: none; }
    .invalid-feedback { color: #dc3545; font-size: 0.85rem; display: none; }
    
    .form-control.is-valid ~ .valid-feedback,
    .form-control.is-invalid ~ .invalid-feedback { display: block; }
    
    .form-control.is-valid { border-color: #28a745 !important; background-image: none !important; }
    .form-control.is-invalid { border-color: #dc3545 !important; background-image: none !important; }

    /* 사번 확인 버튼 */
    #empNoCheck {
        background-color: #f0f0f0; border: 1px solid #ccc;
        border-radius: 5px; padding: 5px 10px; cursor: pointer;
        margin-top: 5px; color: #333;
    }
    #empNoCheck:hover { background-color: #e0e0e0; }
    
    /* 모드 전환 토글 버튼 스타일 */
    .theme-toggle-btn {
        position: absolute; top: 20px; right: 20px;
        background: transparent; border: none; cursor: pointer;
        font-size: 1.5rem; color: inherit; z-index: 1000;
    }

    /* === [숫자 인풋 화살표(증감 버튼) 제거] === */
    input[type="number"]::-webkit-outer-spin-button,
    input[type="number"]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }
    input[type=number] {
        -moz-appearance: textfield; /* Firefox */
    }

    /* === [화이트 모드 (Default)] === */
    body { background-color: #f0f2f5 !important; color: #212529; }
    .card {
        background-color: #ffffff !important; border: 1px solid #e3e6f0;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15) !important;
    }
    .card-header, .card-footer { background-color: #ffffff !important; border-color: #e3e6f0; }
    .people-cync-title {
        color: #333333 !important; font-weight: 300; font-size: 1.75rem;
        text-align: center; margin: 0; padding: 20px 0 0 0;
    }
    .form-control {
        background-color: #fff !important; color: #495057 !important;
        border: 1px solid #ced4da;
    }
    .form-floating label { color: #6c757d !important; }
    .card-footer .small a { color: #007bff !important; }
    .text-muted { color: #6c757d !important; }


    /* === [다크 모드 (.dark-mode 적용 시)] === */
    body.dark-mode {
        background-color: #121212 !important;
        color: #ffffff;
    }
    body.dark-mode .card {
        background-color: transparent !important;
        border: 1px solid #eeeeee24;
        box-shadow: none !important;
    }
    body.dark-mode .card-header {
        background-color: transparent !important;
        border-bottom: 1px solid #eeeeee79;
    }
    body.dark-mode .card-footer {
        background-color: transparent !important;
        border-top: 1px solid #eeeeee79;
    }
    body.dark-mode .people-cync-title { color: #ffffff !important; }
    body.dark-mode .form-control {
        background-color: transparent !important;
        color: #ffffff !important;
        border: 1px solid #555555;
    }
    body.dark-mode .form-control:focus {
        background-color: transparent !important;
        color: #ffffff !important;
        border-color: #e85a6a;
        box-shadow: none !important;
    }
    body.dark-mode .form-floating label { color: #aaaaaa !important; }
    body.dark-mode #empNoCheck {
        background-color: transparent; border: 1px solid #eeeeee79; color: #fff;
    }
    body.dark-mode #empNoCheck:hover { background-color: #333; }
    
    body.dark-mode .valid-feedback { color: #9CDCFE !important; }
    body.dark-mode .invalid-feedback { color: #ff5555 !important; }
    body.dark-mode .form-control.is-valid { border-color: #9CDCFE !important; }
    body.dark-mode .form-control.is-invalid { border-color: #ff5555 !important; }
    
    body.dark-mode .card-footer .small a { color: #aaaaaa !important; }
    body.dark-mode .card-footer .small a:hover { color: #ffffff !important; }
    body.dark-mode .text-muted { color: #adb5bd !important; }
</style>
</head>

<body>
    <button class="theme-toggle-btn" id="themeToggle" title="모드 전환">
        <i class="fas fa-moon"></i>
    </button>

    <div id="layoutAuthentication">
        <div id="layoutAuthentication_content">
            <main>
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-lg-7">
                            <div class="card shadow-lg border-0 rounded-lg mt-5">
                                <div class="card-header">
                                    <h3 class="text-center people-cync-title">사원 계정 등록</h3>
                                </div>
                                <div class="card-body">
                                    <form id='registForm' method='post'>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <div class="form-floating mb-3 mb-md-0">
                                                    <input class="form-control" id="empNo" name="empNo" type="number" placeholder="사원번호" required /> 
                                                    <label for="empNo">사원ID(사원번호)</label>
                                                    <div id="empNoMsg" class="invalid-feedback"></div>
                                                </div>
                                                <button id='empNoCheck' type="button" class="mt-2 mb-3" tabindex="-1">사번확인</button>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input class="form-control" id="empName" name="empName" type="text" placeholder="이름" required /> 
                                                    <label for="empName">이름</label>
                                                    <div id="empNoSuccess" class="valid-feedback"></div>
                                                    <div id="empNoFail" class="invalid-feedback"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-floating mb-3" id="empEmailDiv">
                                            <input class="form-control" id="empEmail" name="empEmail" type="email" placeholder="name@example.com" required /> 
                                            <label for="empEmail">이메일주소</label>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <div class="form-floating mb-3 mb-md-0">
                                                    <input class="form-control" id="empPass" name="empPass" type="password" placeholder="Password" required />
                                                    <label for="empPass">비밀번호</label>
                                                    <div id="pass1Fail" class="invalid-feedback"></div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-floating mb-3 mb-md-0">
                                                    <input class="form-control" id="empPassConfirm" type="password" placeholder="Confirm password" required />
                                                    <label for="empPassConfirm">비밀번호 확인</label>
                                                    <div id="passSuccess" class="valid-feedback"></div>
                                                    <div id="passFail" class="invalid-feedback"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="mt-4 mb-4">
                                            <div class="d-grid">
                                                <button class="btn btn-primary btn-block" type="submit" id="submitBtn" disabled>회원가입</button>
                                            </div>
                                        </div>
                                    </form>
                                    </div>
                                    <div class="card-footer text-center py-3">
                                        <div class="small">
                                            <a href="/member/login">이미 계정이 있으신가요? 로그인 하세요!</a>
                                        </div>
                                    </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
        <div id="layoutAuthentication_footer">
            <footer class="py-4 bg-light mt-auto">
                <div class="container-fluid px-4">
                    <div class="d-flex align-items-center justify-content-between small">
                        <div class="text-muted">Copyright &copy; Your Website 2023</div>
                    </div>
                </div>
            </footer>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="../js/scripts.js"></script>

    <script>
        const toggleBtn = document.getElementById('themeToggle');
        const icon = toggleBtn.querySelector('i');
        const body = document.body;

        const savedTheme = localStorage.getItem('theme');
        const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

        if (savedTheme === 'dark' || (!savedTheme && systemPrefersDark)) {
            body.classList.add('dark-mode');
            icon.classList.remove('fa-moon');
            icon.classList.add('fa-sun');
        } else {
            body.classList.remove('dark-mode');
            icon.classList.remove('fa-sun');
            icon.classList.add('fa-moon');
        }

        toggleBtn.addEventListener('click', () => {
            body.classList.toggle('dark-mode');
            if (body.classList.contains('dark-mode')) {
                icon.classList.remove('fa-moon');
                icon.classList.add('fa-sun');
                localStorage.setItem('theme', 'dark');
            } else {
                icon.classList.remove('fa-sun');
                icon.classList.add('fa-moon');
                localStorage.setItem('theme', 'light');
            }
        });
    </script>
</body>
</html>