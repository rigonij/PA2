<?php if (!empty($_SESSION["token"])): ?>
    <div class="modal fade" id="sanctionPopup" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-danger">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="sanctionPopupTitle">Notification importante</h5>
                </div>
                <div class="modal-body">
                    <p class="fw-bold mb-2" id="sanctionPopupHeading"></p>
                    <div class="mb-3">
                        <label class="text-muted small mb-1">Raison :</label>
                        <div class="p-2 border rounded bg-light" id="sanctionPopupReason"></div>
                    </div>
                    <div class="alert alert-warning mb-0" id="sanctionPopupCounter"></div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" id="sanctionPopupAck">J'ai compris</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        (async function() {
            try {
                const resp = await fetch("pending_sanction.php");
                const data = await resp.json();
                if (!data.success || !data.sanction) return;
                const s = data.sanction;
                const titles = {
                    warning: "Avertissement",
                    ban_temp: "Suspension temporaire",
                    ban_perm: "Bannissement définitif"
                };
                document.getElementById("sanctionPopupTitle").textContent = titles[s.type] || "Sanction";

                let heading = "Vous avez reçu un avertissement.";
                if (s.type === "ban_temp") {
                    const until = s.banned_until ? new Date(s.banned_until).toLocaleString("fr-FR") : "";
                    heading = "Votre compte est suspendu jusqu'au " + until + ".";
                } else if (s.type === "ban_perm") {
                    heading = "Votre compte est banni définitivement.";
                }
                document.getElementById("sanctionPopupHeading").textContent = heading;
                document.getElementById("sanctionPopupReason").textContent = s.reason || "";

                let counter = "";
                if (s.type === "warning") {
                    counter = "Avertissement " + s.warning_count + " / 3. Au 3ᵉ avertissement, votre compte sera suspendu 7 jours automatiquement.";
                } else if (s.type === "ban_temp") {
                    counter = "Bannissement " + s.ban_count + " / 3. Au 3ᵉ bannissement, votre compte sera banni à vie automatiquement.";
                } else {
                    counter = "Cette décision est définitive.";
                }
                document.getElementById("sanctionPopupCounter").textContent = counter;

                const modal = new bootstrap.Modal(document.getElementById("sanctionPopup"));
                modal.show();

                document.getElementById("sanctionPopupAck").addEventListener("click", async () => {
                    try {
                        const ackResp = await fetch("acknowledge_sanction.php", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            body: JSON.stringify({
                                sanction_id: s.id
                            })
                        });
                        const ackData = await ackResp.json();
                        if (ackData.success) {
                            if (s.type === "ban_temp" || s.type === "ban_perm") {
                                window.location.href = "logout.php";
                            } else {
                                modal.hide();
                            }
                        } else {
                            alert(ackData.message || "Erreur");
                        }
                    } catch (e) {
                        alert("Erreur réseau");
                    }
                });
            } catch (e) {}
        })();
    </script>
<?php endif; ?>