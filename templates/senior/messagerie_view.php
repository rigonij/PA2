<?php
$pageTitle = "SilverHappy • Messagerie";
include __DIR__ . "/../common/head.php";
?>

<div class="container py-4">
    <?php include __DIR__ . "/../common/topbar.php"; ?>
    <div class="row g-3">
        <div class="col-lg-3"><?php include __DIR__ . "/../common/sidebar.php"; ?></div>
        <div class="col-lg-9">
            <div class="sh-card p-4 mb-3">
                <h1 class="h4 mb-1">Messagerie privée</h1>
            </div>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="sh-card p-3">
                        <div class="fw-bold mb-2">Conversations</div>
                        <div class="list-group">
                            <?php if (empty($conversations)): ?>
                                <p class="text-secondary small">Aucune conversation.</p>
                            <?php else: ?>
                                <?php foreach ($conversations as $c): ?>
                                    <?php $isActive = ((int)$c["other_id"] === $withID); ?>
                                    <a href="messagerie.php?with=<?= $c['other_id'] ?>"
                                        class="list-group-item list-group-item-action <?= $isActive ? 'active' : '' ?>">
                                        <strong><?= htmlspecialchars($c["other_name"] ?? "Inconnu") ?></strong>
                                        <?php if ($c["unread_count"] > 0): ?>
                                            <span class="badge text-bg-danger float-end"><?= $c["unread_count"] ?></span>
                                        <?php endif; ?>
                                        <br>
                                        <small class="text-truncate d-block">
                                            <?php
                                            $dt = new DateTime($c["last_message_at"] ?? "now");
                                            echo $dt->format("d/m H:i");
                                            ?>
                                        </small>
                                    </a>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="sh-card p-3">
                        <?php if ($withID > 0): ?>
                            <div class="fw-bold mb-2 border-bottom pb-2"><?= htmlspecialchars($withName) ?></div>
                            <div class="border rounded-3 p-3 bg-white mb-3" style="height: 280px; overflow:auto;" id="chatBox">
                                <?php foreach ($messages as $msg): ?>
                                    <?php if ($msg["is_mine"]): ?>
                                        <div class="mb-2 text-end">
                                            <span class="badge text-bg-primary">Moi</span>
                                            <div class="bg-primary text-white p-2 rounded mt-1 d-inline-block text-start">
                                                <?= htmlspecialchars($msg["content"]) ?>
                                            </div>
                                            <div class="text-muted" style="font-size:0.7em"><?php $dt = new DateTime($msg["created_at"] ?? "now");
                                                                                            echo $dt->format("d/m H:i"); ?></div>
                                        </div>
                                    <?php else: ?>
                                        <div class="mb-2">
                                            <span class="badge badge-sh"><?= htmlspecialchars($msg["sender_name"]) ?></span>
                                            <div class="bg-light p-2 rounded mt-1 border">
                                                <?= htmlspecialchars($msg["content"]) ?>
                                            </div>
                                            <div class="text-muted" style="font-size:0.7em"><?php $dt = new DateTime($msg["created_at"] ?? "now");
                                                                                            echo $dt->format("d/m H:i"); ?></div>
                                        </div>
                                    <?php endif; ?>
                                <?php endforeach; ?>
                            </div>
                            <form method="POST" action="messagerie.php" class="d-flex gap-2">
                                <input type="hidden" name="receiver_id" value="<?= $withID ?>">
                                <input class="form-control" name="content" placeholder="Écrire un message..." required>
                                <button class="btn btn-sh-primary" type="submit">Envoyer</button>
                            </form>
                        <?php else: ?>
                            <p class="text-secondary">Sélectionnez une conversation.</p>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    const box = document.getElementById("chatBox");
    if (box) box.scrollTop = box.scrollHeight;
</script>

<?php include __DIR__ . "/../common/footer-scripts.php"; ?>