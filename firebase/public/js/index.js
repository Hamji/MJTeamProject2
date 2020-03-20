const TIME_INTERVAL = 1000 / 120;
let updateScene = 0;
let timeInterval = false;

const timestamp = performance ? () => performance.timeOrigin + performance.now() : () => (new Date()).getTime();

let data = {
    timestamp: timestamp(),
    bpm: 120,
    bit: "4/4"
};
let up = 4;
let down = 4;
let ctx;
let ref;

function rgb2hex(rgb) {
    var hex = Number(rgb).toString(16);
    if (hex.length < 2) {
        hex = "0" + hex;
    }
    return hex;
};

function onInterval() {
    const t = timestamp();
    const scene = Math.round(t / 1000 * 60);
    if (updateScene >= scene)
        return;
    updateScene = scene;

    let elapsed = t - data.timestamp;
    let tick = elapsed / 60000 * data.bpm;
    let current = 1.0 - tick % 1.0;
    let color = rgb2hex(Math.floor(256 * current));
    color = "#" + color + color + color;
    let canvas = ctx.canvas;
    ctx.rect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = color;
    ctx.fill();
}

let bpmSampler = [];
bpmSampler.updatedAt = 0;

const MAX_SAMPLE = 4;

function onTap(e) {
    // const t = timestamp();
    const t = performance ? e.timeStamp + performance.timeOrigin : e.timeStamp;
    if (t - bpmSampler.updatedAt > 5000.0) bpmSampler.length = 0;
    if (bpmSampler.length >= MAX_SAMPLE) bpmSampler.shift();
    bpmSampler.push(t);
    bpmSampler.updatedAt = t;

    data.timestamp = t;
    if (bpmSampler.length > 1) {
        let newBpm = 0;
        for (var i = 1; i < bpmSampler.length; i++)
            newBpm += bpmSampler[i] - bpmSampler[i - 1];
        newBpm /= bpmSampler.length;
        newBpm = 60000.0 / newBpm;
        newBpm = Math.round(newBpm);
        data.bpm = newBpm;
    }
    ref.set(data);
}

function onBitChange() {
    let bit = $("#bitSelector").val();
    if (data.bit != bit) {
        data.bit = bit;
        updateBPM();
        ref.set(data);
    }
}

function updateBPM(_data) {
    data = _data || data;
    let bit = data.bit.split('/');
    $("#bitSelector").val(bit);
    $("#bpm").text(data.bpm);
    let _up = parseFloat(bit[0]);
    let _down = parseFloat(bit[1]);
    if (_down != down) {
        data.bpm *= _down / down;
    }
    up = _up;
    down = _down;
    if (timeInterval) window.clearInterval(timeInterval);
    timeInterval = window.setInterval(onInterval, TIME_INTERVAL);
}

document.addEventListener('DOMContentLoaded', function () {
    // // 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
    // // The Firebase SDK is initialized and available here!
    //
    // firebase.auth().onAuthStateChanged(user => { });
    // firebase.database().ref('/path/to/ref').on('value', snapshot => { });
    // firebase.messaging().requestPermission().then(() => { });
    // firebase.storage().ref('/path/to/ref').getDownloadURL().then(() => { });
    //
    // // 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥

    try {
        let canvas = document.getElementById("canvas");
        ctx = canvas.getContext("2d");
        const app = firebase.app();
        let features = ['auth', 'database', 'messaging', 'storage'].filter(feature => typeof app[feature] === 'function');
        console.log(`Firebase SDK loaded with ${features.join(', ')}`);

        const db = firebase.firestore();
        ref = db.collection("room").doc("test");
        ref.onSnapshot(snapshot => {
            if (snapshot.exists) {
                updateBPM(snapshot.data());
            }
        });
        ref.get().then(snapshot => {
            $("#tapListener").click(onTap);
            $("#bitSelector").change(onBitChange);
            if (snapshot.exists) {
                console.log("Already has data");
                return false
            } else
                return ref.set(data);
        }).then(result => {
            if (result !== false)
                console.log("update default data");
        }).catch(error => {
            console.error(error);
            console.log("Can't update Data");
        });

    } catch (e) {
        console.error(e);
        console.log('Error loading the Firebase SDK, check the console.');
    }
});