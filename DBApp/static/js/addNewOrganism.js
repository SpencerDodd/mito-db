$(function() {
    $('#btnAddNewOrganism').click(function() {
 
        $.ajax({
            url: '/addNewOrganism',
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