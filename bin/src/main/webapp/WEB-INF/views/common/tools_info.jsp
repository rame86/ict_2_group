<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* =========================================
       1. 기본 스타일 (라이트 모드 Default)
       ========================================= */
    .tool-category {
        font-weight: 700; color: #2c3e50; border-left: 4px solid #e85a6a; padding-left: 10px; margin-top: 20px; margin-bottom: 10px;
    }
    .tool-list { list-style: none; padding-left: 0; margin-bottom: 0; }
    .tool-list li { position: relative; padding-left: 15px; margin-bottom: 5px; font-size: 0.95rem; color: #555; }
    .tool-list li::before { content: "-"; position: absolute; left: 0; color: #adb5bd; }
    
    .tool-img-container {
        text-align: center; background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #eee;
    }

    /* 이미지 표시 제어 클래스 */
    .img-dark-mode { display: none; } /* 기본적으로 다크모드 이미지는 숨김 */
    .img-light-mode { display: inline-block; } /* 라이트모드 이미지 표시 */

    /* =========================================
       2. 다크 모드 감지 (@media)
       ========================================= */
    @media (prefers-color-scheme: dark) {
        /* 모달 전체 컨테이너와 헤더/푸터 배경을 진한 회색으로 통일 */
        .modal-content { 
            background-color: #0d0d0d !important; 
            color: #ffffff !important; 
            border: 1px solid #333 !important; 
        }
        .modal-header, .modal-footer, .modal-body { 
            border-color: #333 !important; 
            background-color: #0d0d0d !important; /* 전체 배경 통일 */
        }
        .btn-close { filter: invert(1) grayscale(100%) brightness(200%); }
        
        /* 텍스트 색상 조정 */
        .tool-category { color: #ffffff !important; }
        .tool-list li { color: #cccccc !important; }
        .tool-list li::before { color: #666 !important; }

        /* ⭐ 이미지 컨테이너 배경을 이미지 배경과 비슷한 색상으로 설정 (해결 포인트) */
        .tool-img-container { 
            background-color: #0d0d0d !important; /* 모달 배경색과 동일하게 */
            border-color: #333 !important; 
        }

        /* 이미지 교체 로직 */
        .img-light-mode { display: none !important; }
        .img-dark-mode { display: inline-block !important; }
    }
</style>

<div class="modal fade" id="toolsInfoModal" tabindex="-1" aria-labelledby="toolsInfoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            
            <div class="modal-header bg-secondary text-white">
                <h5 class="modal-title" id="toolsInfoModalLabel">
                    <i class="fas fa-tools me-2"></i> Development Tools & Environment
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                
                <div class="tool-img-container">
                    <img src="/images/developerTools.png" class="img-fluid img-light-mode" alt="Development Tools Light" style="max-height: 300px;">
                    <img src="/images/developerTools_black.png" class="img-fluid img-dark-mode" alt="Development Tools Dark" style="max-height: 300px;">
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="tool-category">Backend & Framework</div>
                        <ul class="tool-list">
                            <li><strong>Java 17:</strong> 프로젝트의 주 언어로 최신 LTS 버전 사용</li>
                            <li><strong>Spring Boot:</strong> 웹 애플리케이션 구축을 위한 메인 프레임워크</li>
                            <li><strong>Spring Framework:</strong> DI, AOP 등 엔터프라이즈급 기능 지원</li>
                            <li><strong>Apache Maven:</strong> 프로젝트 빌드 및 라이브러리 의존성 관리</li>
                        </ul>

                        <div class="tool-category">Database & Mapper</div>
                        <ul class="tool-list">
                            <li><strong>Oracle Database:</strong> 안정적인 데이터 저장 및 관리</li>
                            <li><strong>MyBatis:</strong> Java 객체와 SQL문 사이의 자동 매핑 지원</li>
                            <li><strong>XML:</strong> MyBatis 매퍼 설정 및 데이터 설정 파일</li>
                        </ul>
                    </div>

                    <div class="col-md-6">
                        <div class="tool-category">Frontend</div>
                        <ul class="tool-list">
                            <li><strong>HTML5 / CSS3:</strong> 웹 페이지 구조 및 스타일링 (Bootstrap 5 활용)</li>
                            <li><strong>JavaScript (ES6+):</strong> 동적인 기능 구현 및 이벤트 처리</li>
                            <li><strong>jQuery:</strong> 간편한 DOM 조작 및 AJAX 비동기 통신</li>
                            <li><strong>JSP (Java Server Pages):</strong> 서버 사이드 렌더링 뷰 템플릿</li>
                        </ul>

                        <div class="tool-category">Infrastructure & Tools</div>
                        <ul class="tool-list">
                            <li><strong>Eclipse IDE:</strong> 통합 개발 환경</li>
                            <li><strong>Apache Tomcat:</strong> 웹 애플리케이션 서버 (WAS)</li>
                        </ul>
                    </div>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>