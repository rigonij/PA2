<?php
$pageTitle = "Admin • Conseils";
include __DIR__ . "/../common/head.php";
include __DIR__ . "/../common/header.php";
$items = $items ?? [];
$error = $error ?? "";
?>
<div class="container py-4">
    <div class="sh-card p-4 mb-3 d-flex justify-content-between align-items-start gap-3">
        <div>
            <h1 class="h4 mb-1">Conseils</h1>
            <p class="text-secondary mb-0">Gestion des conseils publiés.</p>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-sh-gold" data-bs-toggle="modal" data-bs-target="#createAdviceModal">Nouveau conseil</button>
            <a class="btn btn-outline-secondary" href="admin_dashboard.php">← Retour</a>
        </div>
    </div>

    <?php if (!empty($error)): ?>
        <div class="alert alert-danger"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <div class="sh-card p-3">
        <div class="table-responsive">
            <table class="table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Titre</th>
                        <th>Extrait</th>
                        <th>Créé le</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (!empty($items)): ?>
                        <?php foreach ($items as $it): ?>
                            <?php
                            $id = (int)($it["id"] ?? 0);
                            $title = $it["title"] ?? "";
                            $excerpt = $it["excerpt"] ?? "";
                            $content = $it["content"] ?? "";
                            $createdAt = $it["created_at"] ?? "";
                            $createdAtFmt = "";
                            if ($createdAt !== "") {
                                $ts = strtotime($createdAt);
                                if ($ts !== false) {
                                    $createdAtFmt = date("d/m/Y H:i", $ts);
                                }
                            }
                            ?>
                            <tr>
                                <td class="fw-bold"><?= htmlspecialchars($title) ?></td>
                                <td><?= htmlspecialchars(mb_strimwidth($excerpt, 0, 80, "...")) ?></td>
                                <td><?= htmlspecialchars($createdAtFmt) ?></td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <button type="button" class="btn btn-outline-secondary btn-sm"
                                            onclick='openEditAdviceModal(<?= $id ?>, <?= json_encode($title, JSON_HEX_APOS | JSON_HEX_QUOT) ?>, <?= json_encode($excerpt, JSON_HEX_APOS | JSON_HEX_QUOT) ?>, <?= json_encode($content, JSON_HEX_APOS | JSON_HEX_QUOT) ?>)'>Éditer</button>
                                        <form method="POST" action="admin_advice.php" onsubmit="return confirm('Supprimer ce conseil ?');" class="m-0">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<?= $id ?>">
                                            <button type="submit" class="btn btn-outline-danger btn-sm">Supprimer</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <tr>
                            <td colspan="4" class="text-secondary">Aucun conseil.</td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="createAdviceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                    <div>
                        <h2 class="h5 mb-1">Nouveau conseil</h2>
                        <p class="text-secondary mb-0">Création d'un conseil.</p>
                    </div>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
                <form method="POST" action="admin_advice.php">
                    <input type="hidden" name="action" value="create">
                    <div class="mb-3">
                        <label class="form-label">Titre</label>
                        <input class="form-control" type="text" name="title" maxlength="150" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Extrait</label>
                        <textarea class="form-control" name="excerpt" rows="2" maxlength="255" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contenu</label>
                        <textarea class="form-control" name="content" rows="8" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-sh-gold w-100">Créer</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editAdviceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content sh-card">
            <div class="modal-body p-4">
                <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                    <div>
                        <h2 class="h5 mb-1">Éditer le conseil</h2>
                        <p class="text-secondary mb-0">Modification.</p>
                    </div>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Fermer</button>
                </div>
                <form method="POST" action="admin_advice.php">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="editAdviceId">
                    <div class="mb-3">
                        <label class="form-label">Titre</label>
                        <input class="form-control" type="text" name="title" id="editAdviceTitle" maxlength="150" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Extrait</label>
                        <textarea class="form-control" name="excerpt" id="editAdviceExcerpt" rows="2" maxlength="255" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contenu</label>
                        <textarea class="form-control" name="content" id="editAdviceContent" rows="8" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-sh-gold w-100">Enregistrer</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function openEditAdviceModal(id, title, excerpt, content) {
        document.getElementById("editAdviceId").value = id;
        document.getElementById("editAdviceTitle").value = title;
        document.getElementById("editAdviceExcerpt").value = excerpt;
        document.getElementById("editAdviceContent").value = content;
        new bootstrap.Modal(document.getElementById("editAdviceModal")).show();
    }
</script>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>