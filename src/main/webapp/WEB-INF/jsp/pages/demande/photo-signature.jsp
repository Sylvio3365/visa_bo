<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="container nt-page">
    <div class="nt-page-head d-flex flex-wrap justify-content-between align-items-start gap-3">
        <div>
            <h1 class="nt-page-title"><i class="fas fa-camera me-2"></i>Photo et Signature</h1>
            <p class="nt-page-subtitle">Capture de la photo et de la signature pour la demande ${demande.idDemande}.</p>
        </div>
        <div>
            <a class="btn btn-outline-secondary d-inline-flex align-items-center px-3 border-0 shadow-sm"
                href="${pageContext.request.contextPath}/demandes/${demande.idDemande}" 
                style="background: #f1f5f9; color: #475569; border-radius: 0.5rem; height: 2.22rem; font-size: 0.85rem;">
                <i class="fas fa-arrow-left me-2"></i>Retour
            </a>
        </div>
    </div>

    <div class="row g-4 mt-2">
        <div class="col-md-6">
            <div class="card shadow-sm nt-form-card">
                <div class="card-body p-4 text-center">
                    <h3 class="card-title nt-title mb-4"><i class="fas fa-user-circle me-2"></i>Photo d'identité</h3>
                    <div class="mb-4 border rounded p-0 bg-dark d-flex align-items-center justify-content-center overflow-hidden" style="height: 250px; position: relative;">
                        <video id="webcam" autoplay playsinline style="width: 100%; height: 100%; object-fit: cover;"></video>
                        <canvas id="photoCanvas" style="display: none; width: 100%; height: 100%; object-fit: cover;"></canvas>
                        <div id="no-webcam" class="position-absolute text-white text-center w-100" style="display: none;">
                            <i class="fas fa-video-slash fa-3x mb-2"></i>
                            <p>Webcam non détectée</p>
                        </div>
                    </div>
                    <div class="d-flex gap-2">
                        <button id="captureBtn" class="btn btn-primary flex-grow-1" style="background: var(--accent, #0c8a7b); border: none;">
                            <i class="fas fa-camera me-2"></i>Capturer
                        </button>
                        <button id="retakeBtn" class="btn btn-outline-secondary" style="display: none;">
                            <i class="fas fa-sync me-2"></i>Reprendre
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card shadow-sm nt-form-card">
                <div class="card-body p-4 text-center">
                    <h3 class="card-title nt-title mb-4"><i class="fas fa-pen-nib me-2"></i>Signature</h3>
                    <div class="mb-4 border rounded bg-white" style="height: 250px; cursor: crosshair; position: relative;">
                        <canvas id="signaturePad" width="500" height="250" style="width: 100%; height: 100%;"></canvas>
                        <button id="clearSignature" class="btn btn-sm btn-outline-danger position-absolute" style="top: 10px; right: 10px;">
                            <i class="fas fa-eraser"></i> Effacer
                        </button>
                    </div>
                    <p class="text-muted small">Signez à l'aide de votre souris ou tablette</p>
                </div>
            </div>
        </div>
        <div class="col-12">
            <div class="card shadow-sm nt-form-card">
                <div class="card-body p-4 text-end">
                    <form id="mainForm" action="${pageContext.request.contextPath}/demandes/valider-photo-signature" method="POST">
                        <input type="hidden" name="idDemande" value="${demande.idDemande}">
                        <input type="hidden" name="photoData" id="photoData">
                        <input type="hidden" name="signatureData" id="signatureData">
                        <button type="submit" class="btn-scan-valid-icon border-0 shadow-sm" 
                             style="background: #1981e3; color: #fff; height: 2.5rem; padding: 0 1.5rem;">
                            <i class="fas fa-check-circle me-2"></i>
                            Terminer Photo et Signature
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // --- WEBCAM LOGIC ---
        const video = document.getElementById('webcam');
        const canvas = document.getElementById('photoCanvas');
        const captureBtn = document.getElementById('captureBtn');
        const retakeBtn = document.getElementById('retakeBtn');
        const photoDataInput = document.getElementById('photoData');
        const noWebcam = document.getElementById('no-webcam');

        if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
            navigator.mediaDevices.getUserMedia({ video: true })
                .then(function(stream) {
                    video.srcObject = stream;
                    video.play();
                })
                .catch(function(err) {
                    console.log("Erreur webcam: ", err);
                    video.style.display = 'none';
                    noWebcam.style.display = 'block';
                });
        }

        captureBtn.addEventListener('click', function() {
            const context = canvas.getContext('2d');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            context.drawImage(video, 0, 0, canvas.width, canvas.height);
            
            const dataUrl = canvas.toDataURL('image/png');
            photoDataInput.value = dataUrl;
            
            video.style.display = 'none';
            canvas.style.display = 'block';
            captureBtn.style.display = 'none';
            retakeBtn.style.display = 'inline-block';
        });

        retakeBtn.addEventListener('click', function() {
            video.style.display = 'block';
            canvas.style.display = 'none';
            captureBtn.style.display = 'inline-block';
            retakeBtn.style.display = 'none';
            photoDataInput.value = '';
        });

        // --- SIGNATURE LOGIC ---
        const sigCanvas = document.getElementById('signaturePad');
        const sigCtx = sigCanvas.getContext('2d');
        const clearBtn = document.getElementById('clearSignature');
        const sigDataInput = document.getElementById('signatureData');
        let painting = false;

        function getMousePos(canvasDom, mouseEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                x: (mouseEvent.clientX - rect.left) * (canvasDom.width / rect.width),
                y: (mouseEvent.clientY - rect.top) * (canvasDom.height / rect.height)
            };
        }

        function startPosition(e) {
            painting = true;
            draw(e);
        }

        function finishedPosition() {
            painting = false;
            sigCtx.beginPath();
            sigDataInput.value = sigCanvas.toDataURL('image/png');
        }

        function draw(e) {
            if (!painting) return;
            e.preventDefault();
            const pos = getMousePos(sigCanvas, e);
            
            sigCtx.lineWidth = 3;
            sigCtx.lineCap = 'round';
            sigCtx.strokeStyle = '#000';

            sigCtx.lineTo(pos.x, pos.y);
            sigCtx.stroke();
            sigCtx.beginPath();
            sigCtx.moveTo(pos.x, pos.y);
        }

        sigCanvas.addEventListener('mousedown', startPosition);
        sigCanvas.addEventListener('mouseup', finishedPosition);
        sigCanvas.addEventListener('mousemove', draw);
        
        // Touch support
        sigCanvas.addEventListener('touchstart', (e) => {
            const touch = e.touches[0];
            const mouseEvent = new MouseEvent("mousedown", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            sigCanvas.dispatchEvent(mouseEvent);
        }, false);
        sigCanvas.addEventListener('touchend', () => {
            sigCanvas.dispatchEvent(new MouseEvent("mouseup"));
        }, false);
        sigCanvas.addEventListener('touchmove', (e) => {
            const touch = e.touches[0];
            const mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            sigCanvas.dispatchEvent(mouseEvent);
        }, false);

        clearBtn.addEventListener('click', function() {
            sigCtx.clearRect(0, 0, sigCanvas.width, sigCanvas.height);
            sigDataInput.value = '';
        });
    });
</script>
