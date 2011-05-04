$(function() {
    $("form").submit(function() {
        if (form_validate()) {
            $("#tr_google_error").remove();
            $("#tr_errors").remove();
            $("#batch_google_error").remove();
            $("#batch_errors").remove();
            return true;
        }
        return false;
    });
});


function form_validate() {

    var validated = true;

    /*

    // text area validation (max 120 caratteri, non vuota)
    if ($('#text').val().trim().length == 0) {
        validated = false;
        alert('testo vuoto');
    }

    if ($('#text').val().trim().length > 120) {
        validated = false;
        alert('massimo 120 caratteri nel testo ammessi');
    }

    // language validation

    selectedLanguageIndex = $("#language")[0].selectedIndex;
    if ($("#language").children("option").eq(selectedLanguageIndex)[0].value.length == 0) {
        validated = false;
        alert('seleziona la lingua');
    }

    */

    return validated;
}

