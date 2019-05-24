const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('.navbar');
  if (navbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= window.innerHeight) {
        navbar.classList.add('navbar-joe-white');
      } else {
        navbar.classList.remove('navbar-joe-white');
      }
    });
  }
}

export { initUpdateNavbarOnScroll };
