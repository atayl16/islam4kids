import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon"]

  connect() {
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.boundHandleClickOutside)
  }

  toggle(event) {
    event.stopPropagation()
    const isOpen = !this.menuTarget.classList.contains("hidden")
    
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    if (this.hasIconTarget) {
      this.iconTarget.classList.add("rotate-180")
    }
    
    // Small delay to avoid immediate click outside
    setTimeout(() => {
      document.addEventListener("click", this.boundHandleClickOutside)
    }, 10)
  }

  close() {
    this.menuTarget.classList.add("hidden")
    if (this.hasIconTarget) {
      this.iconTarget.classList.remove("rotate-180")
    }
    document.removeEventListener("click", this.boundHandleClickOutside)
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  handleEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}

