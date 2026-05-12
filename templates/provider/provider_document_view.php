<?php
$pageTitle = "SilverHappy • Prestataire • Dossier de validation";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";

$existing = $existing ?? ["has_document" => false];
$error = $error ?? "";
$success = $success ?? "";
?>

<div class="container py-4">
    <?php include __DIR__ . "/partials/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3">
            <?php include __DIR__ . "/partials/sidebar.php"; ?>
        </div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Mon dossier de validation</h1>
                <p class="text-secondary mb-0">Envoyez un PDF avec vos diplômes, certifications et la liste des prestations souhaitées.</p>
            </div>

            <?php if (!empty($error)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>

            <?php if (!empty($success)): ?>
                <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
            <?php endif; ?>

            <?php if (!empty($existing["has_document"]) && !empty($existing["filename"])): ?>
                <div class="sh-card p-4 mb-3">
                    <div class="fw-bold mb-2">Dernier document envoyé</div>
                    <div class="d-flex flex-wrap gap-2 mb-2">
                        <span class="badge text-bg-success">Document reçu</span>
                    </div>
                    <div class="text-secondary small">
                        <div><strong>Fichier :</strong> <?= htmlspecialchars($existing["filename"]) ?></div>
                        <div><strong>Taille :</strong> <?= round($existing["size"] / 1024, 1) ?> Ko</div>
                        <div><strong>Envoyé le :</strong> <?= htmlspecialchars(fmt_dt($existing["uploaded_at"])) ?></div>
                        <?php if (!empty($existing["description"])): ?>
                            <div class="mt-2"><strong>Description :</strong></div>
                            <div class="border rounded p-2 mt-1 bg-light" style="white-space: pre-wrap;"><?= htmlspecialchars($existing["description"]) ?></div>
                        <?php endif; ?>
                    </div>
                </div>
            <?php else: ?>
                <div class="sh-card p-4 mb-3">
                    <div class="fw-bold mb-2">Aucun document envoyé</div>
                    <div class="text-secondary small">Envoyez votre PDF ci-dessous pour démarrer la validation de votre compte.</div>
                </div>
            <?php endif; ?>

            <div class="sh-card p-4">
                <div class="fw-bold mb-3">
                    <?= !empty($existing["has_document"]) ? "Remplacer le document" : "Envoyer un document" ?>
                </div>
                <form method="POST" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label">Fichier PDF (max 5 Mo)</label>
                        <input type="file" name="document" class="form-control" accept="application/pdf" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description (optionnel)</label>
                        <textarea name="description" class="form-control" rows="3" maxlength="2000" placeholder="Décris brièvement le contenu du document (diplômes, certifications, prestations souhaitées...)."></textarea>
                    </div>
                    <div class="d-flex justify-content-end">
                        <button class="btn btn-sh-gold" type="submit">Envoyer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<?php include __DIR__ . "/../common/footer.php"; ?>
<?php include __DIR__ . "/../common/footer-scripts.php"; ?>
