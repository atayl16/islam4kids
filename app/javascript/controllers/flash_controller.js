import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { autoDismiss: { type: Number, default: 5000 } }

  connect() {
    if (this.autoDismissValue > 0) {
      this.timeoutId = setTimeout(() => {
        this.dismiss()
      }, this.autoDismissValue)
    }
  }

  disconnect() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  dismiss() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
    this.element.classList.add("opacity-0", "translate-x-full", "transition-all", "duration-300")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}

