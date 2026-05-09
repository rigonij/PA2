<?php
$pageTitle = "Admin • Signalements d'avis";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Signalements d'avis</h1>
            <p class="text-secondary mb-0">Avis signalés par les prestataires.</p>
        </div>
        <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
    </div>
    <div class="sh-card p-3">
        <div id="reportsList">
            <p class="text-secondary mb-0">Chargement...</p>
        </div>
    </div>
</div>

<script>
    (function() {
        const listEl = document.getElementById("reportsList");

        function escapeHtml(s) {
            return String(s).replace(/[&<>"']/g, function(c) {
                return {
                    "&": "&amp;",
                    "<": "&lt;",
                    ">": "&gt;",
                    '"': "&quot;",
                    "'": "&#39;"
                } [c];
            });
        }

        function fmtDate(iso) {
            if (!iso) return "";
            try {
                const d = new Date(iso);
                return d.toLocaleDateString("fr-FR") + " " + d.toLocaleTimeString("fr-FR", {
                    hour: "2-digit",
                    minute: "2-digit"
                });
            } catch (e) {
                return iso;
            }
        }

        function statusBadge(s) {
            if (s === "pending") return '<span class="badge text-bg-warning">En attente</span>';
            if (s === "reviewed") return '<span class="badge text-bg-success">Traité</span>';
            if (s === "dismissed") return '<span class="badge text-bg-secondary">Rejeté</span>';
            return s;
        }

        async function load() {
            try {
                const r = await fetch("admin_review_reports.php?api=1");
                const j = await r.json();
                if (!j.success) {
                    listEl.innerHTML = '<p class="text-danger mb-0">' + escapeHtml(j.message || "Erreur") + '</p>';
                    return;
                }
                if (!j.reports || j.reports.length === 0) {
                    listEl.innerHTML = '<p class="text-secondary mb-0">Aucun signalement.</p>';
                    return;
                }
                listEl.innerHTML = '<div class="table-responsive"><table class="table align-middle mb-0">' +
                    '<thead><tr><th>Date</th><th>Prestataire</th><th>Avis</th><th>Raison signalement</th><th>Statut</th><th>Actions</th></tr></thead><tbody>' +
                    j.reports.map(function(rep) {
                        const stars = "★".repeat(rep.rating) + "☆".repeat(5 - rep.rating);
                        const comment = rep.comment ? '<div class="small">' + escapeHtml(rep.comment) + '</div>' : '<div class="small text-secondary">(pas de commentaire)</div>';
                        const actions = rep.status === "pending" ?
                            '<button class="btn btn-outline-danger btn-sm me-1 del-btn" data-review-id="' + rep.review_id + '" data-report-id="' + rep.id + '">Supprimer l\'avis</button>' +
                            '<button class="btn btn-outline-secondary btn-sm dismiss-btn" data-report-id="' + rep.id + '">Rejeter signalement</button>' :
                            '—';
                        return '<tr>' +
                            '<td class="small">' + fmtDate(rep.created_at) + '</td>' +
                            '<td>' + escapeHtml(rep.company_name) + '</td>' +
                            '<td><span class="text-warning">' + stars + '</span> par ' + escapeHtml(rep.senior_name) + comment + '</td>' +
                            '<td class="small">' + escapeHtml(rep.reason) + '</td>' +
                            '<td>' + statusBadge(rep.status) + '</td>' +
                            '<td>' + actions + '</td></tr>';
                    }).join("") +
                    '</tbody></table></div>';

                document.querySelectorAll(".del-btn").forEach(function(b) {
                    b.addEventListener("click", async function() {
                        if (!confirm("Supprimer cet avis ?")) return;
                        await fetch("admin_review_reports.php?api=1&review_id=" + b.dataset.reviewId, {
                            method: "DELETE"
                        });
                        await fetch("admin_review_reports.php?api=1&report_id=" + b.dataset.reportId, {
                            method: "PUT",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            body: JSON.stringify({
                                status: "reviewed"
                            })
                        });
                        load();
                    });
                });
                document.querySelectorAll(".dismiss-btn").forEach(function(b) {
                    b.addEventListener("click", async function() {
                        await fetch("admin_review_reports.php?api=1&report_id=" + b.dataset.reportId, {
                            method: "PUT",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            body: JSON.stringify({
                                status: "dismissed"
                            })
                        });
                        load();
                    });
                });
            } catch (e) {
                listEl.innerHTML = '<p class="text-danger mb-0">Erreur réseau</p>';
            }
        }
        load();
    })();
</script>

<?php
include __DIR__ . "/../common/footer-scripts.php";
