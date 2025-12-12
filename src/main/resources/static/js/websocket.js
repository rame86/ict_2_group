function updateSidebarBadge() {
	
    $.ajax({
        url: "/approve/getWaitingCount", 
        type: "GET",
        dataType: "json",
        success: function(response) {
			const waitingCount = response;
            const badgeElement = $("#badgeId");
            
            if (waitingCount > 0) {
                badgeElement.text(waitingCount);
                badgeElement.show();
				$("#approvalIcon").addClass("icon-notify");
            } else {
				badgeElement.text("");
                badgeElement.hide();
				$("#approvalIcon").removeClass("icon-notify");
            }
        },
        error: function(xhr, status, error) {
            console.error("뱃지 업데이트 실패:", error);
			console.error("오류 상세:", xhr.status, xhr.responseText);
        }
    });
	
}