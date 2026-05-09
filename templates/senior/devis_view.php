<?php
$pageTitle = "SilverHappy • Devis";
$isSeniorUi = true;
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>

<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>

    <div class="row g-3">
        <div class="col-lg-3"><?php include __DIR__ . "/../common/sidebar.php"; ?></div>

        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Devis</h1>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <div class="sh-card p-4">
                        <div class="fw-bold mb-2">Demander un devis</div>
                        <div class="mb-3">
                            <label class="form-label">Objet</label>
                            <input class="form-control" id="qSubject" placeholder="Ex: aide à domicile 2h/semaine" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Détails</label>
                            <textarea class="form-control" id="qDetails" rows="4" placeholder="Informations complémentaires..."></textarea>
                        </div>
                        <button class="btn btn-sh-gold" type="button" onclick="sendQuoteMock()">Envoyer (mock)</button>
                        <div class="text-secondary small mt-2" id="qMsg"></div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="sh-card p-4">
                        <div class="fw-bold mb-2">Historique (mock)</div>
                        <div class="table-responsive">
                            <table class="table mb-0 align-middle">
                                <thead>
                                    <tr>
                                        <th>Réf</th>
                                        <th>Date</th>
                                        <th>Statut</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="quoteTable">
                                    <tr>
                                        <td>DV-2026-014</td>
                                        <td>22/02/2026</td>
                                        <td><span class="badge text-bg-warning">En attente</span></td>
                                        <td><button class="btn btn-outline-secondary btn-sm" type="button">Voir</button></td>
                                    </tr>
                                    <tr>
                                        <td>DV-2026-002</td>
                                        <td>07/02/2026</td>
                                        <td><span class="badge text-bg-success">Accepté</span></td>
                                        <td><button class="btn btn-outline-secondary btn-sm" type="button">Voir</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function sendQuoteMock() {
        const sub = document.getElementById("qSubject").value.trim() || "Demande";
        const ref = "DV-" + new Date().getFullYear() + "-" + String(Math.floor(Math.random() * 900) + 100).padStart(3, "0");
        const tr = document.createElement("tr");
        tr.innerHTML = `<td>${ref}</td><td>${new Date().toLocaleDateString('fr-FR')}</td><td><span class="badge text-bg-warning">En attente</span></td><td><button class="btn btn-outline-secondary btn-sm" type="button">Voir</button></td>`;
        document.getElementById("quoteTable").prepend(tr);
        document.getElementById("qMsg").textContent = `Devis envoyé (mock) : ${sub} • Réf ${ref}`;
    }
</script>

<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>