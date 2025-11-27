window.addEventListener('DOMContentLoaded', event => {
    // Simple-DataTables
    // https://github.com/fiduswriter/Simple-DataTables/wiki

    const datatablesSimple = document.getElementById('datatablesSimple');
	
	// 테이블 기본
    if (datatablesSimple) {
        new simpleDatatables.DataTable(datatablesSimple);
    }
	
	const tableSimpleElement1 = document.getElementById('tableSimple1'); 
	
	// 변형
	if (tableSimpleElement1) {
		new simpleDatatables.DataTable(tableSimpleElement1, {
			perPageSelect: false,
			searchable: false
		});
	}
	
	const tableSimpleElement2 = document.getElementById('tableSimple2'); 
		    
	if (tableSimpleElement2) {
		new simpleDatatables.DataTable(tableSimpleElement2, {
			perPageSelect: false,
			searchable: false
		});
	}
	
});
