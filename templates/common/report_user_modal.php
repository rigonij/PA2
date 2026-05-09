<div class="modal fade" id="reportUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Signaler un utilisateur</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="reportUserId">
                <p class="mb-2">Vous signalez : <span class="fw-bold" id="reportUserName"></span></p>
                <p class="text-muted small">Un administrateur examinera votre signalement. Les abus de signalement peuvent entraîner des sanctions.</p>
                <div class="mb-3">
                    <label class="form-label">Motif du signalement</label>
                    <textarea class="form-control" id="reportReason" rows="4" placeholder="Décrivez précisément le comportement..." required></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button class="btn btn-danger" id="reportSubmit">Envoyer</button>
            </div>
        </div>
    </div>
</div>

<script>
    window.openReportUserModal = function(userId, userName) {
        document.getElementById("reportUserId").value = userId;
        document.getElementById("reportUserName").textContent = userName;
        document.getElementById("reportReason").value = "";
        new bootstrap.Modal(document.getElementById("reportUserModal")).show();
    };

    document.getElementById("reportSubmit").addEventListener("click", async () => {
        const userId = parseInt(document.getElementById("reportUserId").value);
        const reason = document.getElementById("reportReason").value.trim();
        if (!reason) {
            alert("Le motif est requis");
            return;
        }
        try {
            const resp = await fetch("user_report.php", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    reported_id: userId,
                    reason: reason
                })
            });
            const data = await resp.json();
            if (data.success) {
                alert("Signalement envoyé. Un administrateur l'examinera.");
                bootstrap.Modal.getInstance(document.getElementById("reportUserModal")).hide();
            } else {
                alert(data.message || "Erreur");
            }
        } catch (e) {
            alert("Erreur réseau");
        }
    });
</script>