<script>
    document.addEventListener('DOMContentLoaded', function() {
        const toggle = document.querySelector('.menu-toggle');
        const menu = document.querySelector('.BarreLat');
        if (toggle && menu) toggle.addEventListener('click', () => menu.classList.toggle('open'));
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>