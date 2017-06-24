var key_metadata;
var key_stl;

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

function generate_key() {
    $("#generated_key").hide();
    $("#generate_button").prop("disabled", true);
    $("#description").hide();
    $("#please_wait").show();
    get_data = $.param({
        "key": $("#key_type").val(),
        "outline": $("#key_outline").val(),
        "warding": $("#key_warding").val(),
        "bitting": $("#key_bitting").val(),
    });

    var xhr = new XMLHttpRequest();
    xhr.open("GET", keygen_endpoint + "?" + get_data, true);
    xhr.responseType = "arraybuffer";

    xhr.onload = function(e) {
        if (this.status == 200) {
            key_stl = this.response;
            preview_load(key_stl);
            preview_animate();
            $("#generated_key").show();

            var blob = new Blob([key_stl], {type: "application/sla"});
            var objectUrl = URL.createObjectURL(blob);
            var bitting = $("#key_bitting").val();
            var filename = (bitting ? bitting : "keyblank") + ".stl";
            $("#key_download").attr("href", objectUrl).attr("download", filename);
        } else {
            alert("An error occurred");
        }
        $("#please_wait").hide();
        $("#generate_button").prop("disabled", false);
    };

    xhr.send();
}

function handle_hash() {
    hash = window.location.hash;
    if(hash == "#about") {
        $("#generator").hide();
        $("#about").show();
        $("#about_link").hide();
    } else {
        $("#about").hide();
        $("#generator").show();
        $("#about_link").show();
    }
}

$(document).ready(function() {
    $("#key_type").on("change", populate_outlines_wardings);
    $("#key_form").submit(function(e) {generate_key(); e.preventDefault();});
    $(window).on('hashchange', handle_hash);

    populate_types();
    preview_init();
    handle_hash();
});
