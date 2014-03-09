$('.modal-title').html('<%= @photo.title %>');
$('.modal-body').html('<%= j(render "modal_photo", photo: @photo) %>');
$('#myModal').modal();
