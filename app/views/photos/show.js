$('.modal-title').html('<%= @photo.description %>');
$('.modal-body').html('<%= j(render "photos/modal_photo", photo: @photo) %>');
$('#myModal').modal();
