var container;

var camera, cameraTarget, scene, renderer;

function preview_load(data) {
    scene = new THREE.Scene();

    var loader = new THREE.STLLoader();
    geometry = loader.parse( data );

    geometry.computeBoundingBox();
    var centerX = 0.5 * (geometry.boundingBox.max.x + geometry.boundingBox.min.x);
    var centerY = 0.5 * (geometry.boundingBox.max.y + geometry.boundingBox.min.y);
    var centerZ = 0.5 * (geometry.boundingBox.max.z + geometry.boundingBox.min.z);

    var material = new THREE.MeshPhongMaterial( { color: 0x775500, specular: 0x111111, shininess: 200 } );
    var mesh = new THREE.Mesh( geometry, material );

    var scale = 0.03;
    mesh.position.set(-centerX * scale, -centerY * scale, -centerZ * scale);
    //mesh.rotation.set( - Math.PI / 2, 0, 0 );
    mesh.scale.set( scale, scale, scale );

    mesh.castShadow = true;
    mesh.receiveShadow = true;

    scene.add( mesh );

    // Lights

    scene.add( new THREE.HemisphereLight( 0x443333, 0x111122 ) );

    addShadowedLight( 1, 1, 1, 0xffffff, 1.35 );
    addShadowedLight( -1, 1, -1, 0xffffff, 1.35 );
}

function preview_init() {
    container = document.getElementById("key_preview");

    camera = new THREE.PerspectiveCamera( 35, container.offsetWidth / container.offsetHeight, 1, 15 );
    camera.position.set( 3, 0, 3 );

    cameraTarget = new THREE.Vector3( 0, 0, 0 );

    // renderer

    renderer = new THREE.WebGLRenderer( { antialias: true } );
    renderer.setClearColor( 0xFFFFFF );
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( container.offsetWidth, container.offsetHeight );

    renderer.gammaInput = true;
    renderer.gammaOutput = true;

    renderer.shadowMap.enabled = true;
    renderer.shadowMap.renderReverseSided = false;

    container.appendChild( renderer.domElement );

    window.addEventListener( 'resize', onWindowResize, false );
}

function addShadowedLight( x, y, z, color, intensity ) {

    var directionalLight = new THREE.DirectionalLight( color, intensity );
    directionalLight.position.set( x, y, z );
    scene.add( directionalLight );

    directionalLight.castShadow = true;

    var d = 1;
    directionalLight.shadow.camera.left = -d;
    directionalLight.shadow.camera.right = d;
    directionalLight.shadow.camera.top = d;
    directionalLight.shadow.camera.bottom = -d;

    directionalLight.shadow.camera.near = 1;
    directionalLight.shadow.camera.far = 4;

    directionalLight.shadow.mapSize.width = 1024;
    directionalLight.shadow.mapSize.height = 1024;

    directionalLight.shadow.bias = -0.005;

}

function onWindowResize() {

    camera.aspect = container.offsetWidth / container.offsetHeight;
    camera.updateProjectionMatrix();

    renderer.setSize( container.offsetWidth, container.offsetHeight );

}

function preview_animate() {
    if(scene) {
        onWindowResize();
        requestAnimationFrame( preview_animate );

        render();
    }
}

function render() {

    var timer = Date.now() * 0.0005;

    camera.position.x = Math.cos( timer ) * 3;
    camera.position.z = Math.sin( timer ) * 3;

    camera.lookAt( cameraTarget );

    renderer.render( scene, camera );

}
