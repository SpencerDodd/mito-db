$(function() {
    $('#btnDeleteOrganism').click(function() {
 
        $.ajax({
            url: '/deleteOrganism',
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