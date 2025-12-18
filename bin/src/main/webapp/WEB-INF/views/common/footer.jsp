<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="py-4 bg-light mt-auto">
    <div class="container-fluid px-4">
        <div class="d-flex align-items-center justify-content-between small">
            <div class="text-muted">Copyright &copy; ICT Group Two Middle Project</div>
            <div>
                <a href="#" class="text-decoration-none" onclick="loadDeveloperModal(event)">
                    <i class="fas fa-code"></i> 개발자 정보
                </a> 
                &middot;
                <a href="#" class="text-decoration-none" onclick="loadToolsModal(event)">
                    <i class="fas fa-toolbox"></i> 개발툴 정보
                </a>
            </div>
        </div>
    </div>
</footer>

<div id="modal-placeholder"></div>

<script>
    // 개발자 정보 모달 로드 함수
    function loadDeveloperModal(e) {
        e.preventDefault();
        if ($('#developerInfoModal').length > 0) {
            var myModal = new bootstrap.Modal(document.getElementById('developerInfoModal'));
            myModal.show();
            return;
        }
        const modalUrl = "<c:url value='/common/developerInfo'/>";
        $('#modal-placeholder').load(modalUrl, function(response, status, xhr) {
            if (status == "error") {
                alert("개발자 정보를 불러오는데 실패했습니다.");
            } else {
                var myModal = new bootstrap.Modal(document.getElementById('developerInfoModal'));
                myModal.show();
            }
        });
    }

    // 개발툴 정보 모달 로드 함수
    function loadToolsModal(e) {
        e.preventDefault();

        // 이미 로드되어 있다면 바로 보여줌
        if ($('#toolsInfoModal').length > 0) {
            var myModal = new bootstrap.Modal(document.getElementById('toolsInfoModal'));
            myModal.show();
            return;
        }

        // 컨트롤러 요청 (toolsInfo)
        const modalUrl = "<c:url value='/common/toolsInfo'/>";
        $('#modal-placeholder').load(modalUrl, function(response, status, xhr) {
            if (status == "error") {
                console.log("Error: " + xhr.status);
                alert("개발툴 정보를 불러오는데 실패했습니다.");
            } else {
                // 로드 성공 시 모달 띄우기
                var myModal = new bootstrap.Modal(document.getElementById('toolsInfoModal'));
                myModal.show();
            }
        });
    }
</script>