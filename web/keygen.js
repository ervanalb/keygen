keygen_endpoint = "http://localhost:8080";

var key_metadata;

function populate_types() {
    $.getJSON( keygen_endpoint, function( data ) {
        key_metadata = data;

        $("#key_type").empty();
        $.each(data, function(i, key_type) {
            $("#key_type").append($('<option/>', { 
                value: key_type.filename,
                text : key_type.name
            }));
        });
        if(key_metadata.length > 0) {
            $("#key_type").val(key_metadata[0].filename);
            populate_outlines_wardings();
        }
    });
}

function populate_outlines_wardings() {
    key_filename = $("#key_type").val();
    $("#key_outline").empty();
    $("#key_warding").empty();
    $.each(key_metadata, function(i, key_type) {
        if(key_type.filename == key_filename) {
            $.each(key_type.outlines, function(i, key_outline) {
                $("#key_outline").append($('<option/>', {
                    value: key_outline,
                    text : key_outline
                }));
            });
            $.each(key_type.wardings, function(i, key_warding) {
                $("#key_warding").append($('<option/>', {
                    value: key_warding,
                    text : key_warding
                }));
            });
            $("#key_description").text(key_type.description);
        }
    });
}

$(document).ready(function() {
    $("#key_type").on("change", populate_outlines_wardings);
    populate_types();
});
