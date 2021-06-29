import Swal from 'sweetalert2';

const initSwal2 = () => {
  const initSweetalert = (selector, options = {}) => {
    const selectorEl = document.querySelector(selector)
    if (selectorEl) {
      options.text = selectorEl.childNodes[1].innerText
      Swal.fire(options);
    }
  };

  initSweetalert('#success', { title: "Pronto!", icon: "success" });
  initSweetalert('#failed', { title: "Oh no!", icon: "warning" });
}

export { initSwal2 };