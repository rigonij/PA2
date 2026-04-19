function setActiveLink() {
  const path = location.pathname.split("/").pop() || "index.html";
  document.querySelectorAll("[data-nav]").forEach(a => {
    const target = a.getAttribute("href");
    if (target === path) a.classList.add("active");
  });
}

function isLoggedIn(){
  return localStorage.getItem("sh_logged_in") === "1";
}



function requireAuth(){
  const publicPages = ["login.html", "register.html"];
  const current = location.pathname.split("/").pop() || "index.html";
  if (!publicPages.includes(current) && !isLoggedIn()){
    location.href = "login.html";
  }
}

function logout(){
  localStorage.removeItem("sh_logged_in");
  localStorage.removeItem("sh_user");
  location.href = "login.html";
}

document.addEventListener("DOMContentLoaded", () => {
  setActiveLink();
});