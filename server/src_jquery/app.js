
$(document).ready(function() {

    // Manage checkbox events

    $(document).on('change', ':checkbox', function() {
        disableOthers.call(this);
        pdfDidSelected();
        updateButtonAccessibility();
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

    function updateButtonAccessibility() {
        var nothingIsChecked = $(':checkbox:checked').length == 0;

        if(nothingIsChecked)
            $('#upload-btn').attr('disabled', true);
        else
            $('#upload-btn').attr('disabled', false);
    }

    // Manage button events

    $('#upload-btn').click(function(){
        window.webkit.messageHandlers.SendDataObserver.postMessage("Hey WebView! Send the data of the selected file.");
    });

    $(document).on( "uploadFile", function( event, stringBase64 ) {
        $('#result').text(stringBase64);
    });
});

function loadPDFList(fileNamesArray) {
    fileNamesArray.forEach(function(element, index) {

        const checkbox = `<input class="doc" id="doc-${index}" type="checkbox" value="${element}"> ${element}`;
        const checkContainer = `<div class="checkbox-container">${checkbox}</div>`;

        $('#documentList').append(checkContainer);
    });
}
