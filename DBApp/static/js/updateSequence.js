$(function() {
    $('#btnUpdateSequence').click(function() {
 
        $.ajax({
            url: '/updateSequence',
            data: $('form').serialize(),
            type: 'POST',
            success: function(response) {
                console.log(response);
            },
            error: function(error) {
                console.log(error);
            }
        });
    });
});