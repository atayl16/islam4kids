import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon"]

  connect() {
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    this.boundHandleEscape = this.handleEscape.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.boundHandleClickOutside)
    document.removeEventListener("keydown", this.boundHandleEscape)
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
    const button = this.element.querySelector('button[aria-expanded]')
    if (button) {
      button.setAttribute('aria-expanded', 'true')
    }
    if (this.hasIconTarget) {
      this.iconTarget.classList.add("rotate-180")
    }
    
    document.addEventListener("keydown", this.boundHandleEscape)
    
    // Small delay to avoid immediate click outside
    setTimeout(() => {
      document.addEventListener("click", this.boundHandleClickOutside)
    }, 10)
  }

  close() {
    this.menuTarget.classList.add("hidden")
    const button = this.element.querySelector('button[aria-expanded]')
    if (button) {
      button.setAttribute('aria-expanded', 'false')
    }
    if (this.hasIconTarget) {
      this.iconTarget.classList.remove("rotate-180")
    }
    document.removeEventListener("click", this.boundHandleClickOutside)
    document.removeEventListener("keydown", this.boundHandleEscape)
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  handleEscape(event) {
    if (event.key === "Escape") {
      const isOpen = !this.menuTarget.classList.contains("hidden")
      if (isOpen) {
        this.close()
      }
    }
  }
}

