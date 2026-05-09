<?php
$newInterventionsCount = 0;
if (!empty($_SESSION["token"])) {
    $apiBaseSidebar = $apiBase ?? "http://127.0.0.1:8081";
    $ch = curl_init($apiBaseSidebar . "/api/provider/interventions/new-count");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ["X-Token: " . $_SESSION["token"]]);
    curl_setopt($ch, CURLOPT_TIMEOUT, 2);
    $resp = curl_exec($ch);
    curl_close($ch);
    if ($resp !== false) {
        $d = json_decode($resp, true);
        if (!empty($d["success"])) {
            $newInterventionsCount = (int)($d["count"] ?? 0);
        }
    }
}
?>
<div class="sh-card p-3 sh-nav">
    <div class="d-flex align-items-center justify-content-between mb-1">
        <div class="fw-bold">Menu</div>
        <span class="badge badge-sh">Provider</span>
    </div>
    <a data-nav href="provider_dashboard.php">Dashboard</a>
    <a data-nav href="provider_document.php">Documents</a>
    <div class="sh-nav-section">Gestion</div>
    <a data-nav href="provider_disponibilites.php">Disponibilités</a>
    <a data-nav href="provider_services.php">Mes services</a>
    <a data-nav href="provider_interventions.php">
        Gestion des réservations
        <?php if ($newInterventionsCount > 0): ?>
            <span class="badge text-bg-danger ms-1"><?= $newInterventionsCount ?></span>
        <?php endif; ?>
    </a>
    <a data-nav href="provider_reviews.php" class="list-group-item list-group-item-action">Mes avis</a>
    <a data-nav href="provider_planning.php">Planning</a>
    <a data-nav href="provider_messagerie.php">Messagerie</a>
    <div class="sh-nav-section">Finance</div>
    <a data-nav href="provider_finances.php">Revenus</a>
    <a data-nav href="provider_factures.php">Mes factures</a>
    <div class="sh-nav-section">Compte</div>
    <a data-nav href="provider_profil.php">Mon profil</a>
    <a data-nav href="logout.php">Déconnexion</a>
</div>