const observer = new IntersectionObserver((entries)=> {
    const {target, isIntersecting} = entries[0]

    console.log({target, isIntersecting})
    if (isIntersecting) {
        target.classList.add('appear');
        return; // if we added the class, exit the function
      }

      target.classList.remove('appear');
  });

document.querySelectorAll('[data-appearable]').forEach(
    appearable => {
        observer.observe(appearable);
    }
)