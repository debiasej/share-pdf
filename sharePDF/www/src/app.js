
$(document).ready(function() {

    const baseUrl = "http://192.168.1.36";
    const port = ":3000";
    var PDFData = {id:"", base64String: ""};

    // Manage checkbox events

    $(document).on('change', ':checkbox', function() {
        disableOthers.call(this);
        pdfDidSelected();
        updateButtonAccessibility();
    });

    function disableOthers() {
        var $othersCheckboxes = $('#document-list').find('input:checkbox').not($(this));

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

    $(document).on( "uploadFile", function( event, title, data ) {
        PDFData.id = title;
        PDFData.base64String = data;
        uploadPDF(`${baseUrl}${port}/upload`, PDFData);
    });

    $('.title').click(function() {
      window.webkit.messageHandlers.UpdateListObserver.postMessage("Hey WebView! Update the list of documents.");
    });
});

function loadPDFList(fileNamesArray) {
    $('#document-list').empty();

    fileNamesArray.forEach(function(element, index) {
        const checkbox = `<input class="doc" id="doc-${index}" type="checkbox" value="${element}"> ${element}`;
        const checkContainer = `<div class="checkbox-container">${checkbox}</div>`;
        $('#document-list').append(checkContainer);
    });

    updateListHeight();
}

function updateListHeight() {
  var screenHeight = $('body').height();
  var headerAndFooterHeight = 213;
  $('#document-list').height( screenHeight - headerAndFooterHeight);
}

function clearCheckedInputs() {
  $("input:checkbox:checked").trigger('click');
  setTimeout(function() {
    $('#result').text("");
    $('#status').text("");
  }, 2000 );
}

function uploadPDF(url, data) {
    return $.ajax({
        url: url,
        type: 'POST',
        data: JSON.stringify(data),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        async: false,
        success: function(res, status) {
            var resultMsg = `Upload: [${res.msg}]`;
            var statusMsg = `Response Status: [${status}]`;
            $('#result').text(resultMsg);
            $('#status').text(statusMsg);
            clearCheckedInputs();
        }
    });
}
