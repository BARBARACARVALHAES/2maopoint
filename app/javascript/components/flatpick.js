import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt.js";

const initFlatpick = () => {
  if (document.getElementById("flat_datetime")) {
    const el = document.getElementById("flat_datetime");
    flatpickr(el, {
      enableTime: true,
      altInput: true,
      minDate: "today",
      altFormat: "F j, Y - h:i K",
      dateFormat: "d-m-Y H:M",
      defaultHour: 23,
      defaultMinute: 59,
      minuteIncrement: 1,
      locale: Portuguese,
    });
  }
  if (document.getElementById("flat_date")) {
    const el = document.getElementById("flat_date");
    flatpickr(el, {
      enableTime: false,
      altInput: true,
      altFormat: "F j, Y às h:i K",
      dateFormat: "d-m-Y",
      locale: Portuguese,
    });
  }
};

export { initFlatpick };
