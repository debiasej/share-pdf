
$(document).ready(function() {

    $(document).on('change', ':checkbox', function() {
        disableOthers.call(this);
        pdfDidSelected();
    });

    function disableOthers() {
        var $othersCheckboxes = $('#documentList').find('input:checkbox').not($(this));

        if ($(this).prop('checked')) {
            $othersCheckboxes.attr('disabled', true);
        } else {
            $othersCheckboxes.attr('disabled', false);
        }
    }

    function pdfDidSelected() {
        window.webkit.messageHandlers.SelectedFileObserver.postMessage($('input:checked').val());
    }

});

function loadPDFList(fileNamesArray) {
    fileNamesArray.forEach(function(element, index) {

        const checkbox = `<input class="doc" id="doc-${index}" type="checkbox" value="${element}"> ${element}`;
        const checkContainer = `<div class="checkbox-container">${checkbox}</div>`;

        $('#documentList').append(checkContainer);
    });
}


function API() {

}
