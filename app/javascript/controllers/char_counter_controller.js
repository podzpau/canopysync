import { Controller } from "@hotwired/stimulus"

// Tracks character count for a text field.
// data-char-counter-min-value  — green threshold start
// data-char-counter-max-value  — red threshold start
// data-char-counter-warn-value — amber threshold start (defaults to max - 10)
export default class extends Controller {
  static targets = ["input", "count"]
  static values  = { min: Number, max: Number, warn: Number }

  connect() {
    this.update()
  }

  update() {
    const len  = this.inputTarget.value.length
    const min  = this.minValue
    const max  = this.maxValue
    const warn = this.warnValue || (max - 10)

    this.countTarget.textContent = len

    this.countTarget.className = "text-xs font-medium tabular-nums "
    if (len > max) {
      this.countTarget.className += "text-red-600"
    } else if (len >= warn) {
      this.countTarget.className += "text-amber-600"
    } else if (len >= min) {
      this.countTarget.className += "text-emerald-600"
    } else {
      this.countTarget.className += "text-gray-400"
    }
  }
}
