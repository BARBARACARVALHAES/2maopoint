import flatpickr from "flatpickr";

const initFlatpick = () => {
  if(document.getElementById("flat_datetime")) {
    const el = document.getElementById("flat_datetime");
    flatpickr(el, {
      enableTime: true,
      altInput: true,
      minDate: "today",
      altFormat: "F j, Y at h:i K",
      dateFormat: "Y-m-d H:i",
      defaultHour: 23,
      defaultMinute: 59,
      minuteIncrement: 1,
    });
  }
  if(document.getElementById("flat_date")) {
    const el = document.getElementById("flat_date");
    flatpickr(el, {
      enableTime: false,
      altInput: true,
      altFormat: "F j, Y at h:i K",
      dateFormat: "Y-m-d",
    });
  }
};

export { initFlatpick };
