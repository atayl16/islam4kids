import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["content", "body", "container"]
  static values = { open: Boolean }

  connect() {
    // Handle Escape key to close modal
    this.boundHandleEscape = this.handleEscape.bind(this)
    document.addEventListener('keydown', this.boundHandleEscape)
    
    // Find modal container by ID if not using target
    if (!this.hasContainerTarget) {
      this.modalContainer = document.getElementById('printable-modal') || document.getElementById('game-modal')
    }
    
    // Set initial state
    this.updateVisibility()
  }

  disconnect() {
    // Clean up event listener
    document.removeEventListener('keydown', this.boundHandleEscape)
  }

  open(event) {
    const printableId = event.currentTarget.dataset.printableId
    const gameId = event.currentTarget.dataset.gameId
    
    // Find content by ID (supports both printables and games)
    const contentId = printableId ? `printable-modal-content-${printableId}` : `game-modal-content-${gameId}`
    const content = document.getElementById(contentId)
    
    if (content && this.hasBodyTarget) {
      // For games, extract title and set it in the modal header
      if (gameId) {
        const gameTitle = content.dataset.gameTitle
        if (gameTitle) {
          const modalHeader = document.querySelector('#game-modal h3')
          if (modalHeader) {
            modalHeader.textContent = gameTitle
          }
        }
      }
      
      this.bodyTarget.innerHTML = content.innerHTML
      this.openValue = true
    }
  }

  close(event) {
    // Close if clicking the backdrop, close button, or if event is null (escape key)
    if (!event) {
      this.openValue = false
      return
    }
    
    const modalContainer = this.hasContainerTarget ? this.containerTarget : this.modalContainer
    const clickedElement = event.target
    
    // Check if clicked element is the backdrop or close button
    if (clickedElement === modalContainer || clickedElement.closest('[data-action*="modal#close"]') || clickedElement.closest('button[data-action*="modal#close"]')) {
      this.openValue = false
    } else {
      // Stop propagation for modal content clicks (so backdrop click works)
      event.stopPropagation()
    }
  }

  handleEscape(event) {
    if (event.key === 'Escape' && this.openValue) {
      this.openValue = false
    }
  }

  openValueChanged() {
    this.updateVisibility()
  }

  updateVisibility() {
    const modalContainer = this.hasContainerTarget ? this.containerTarget : this.modalContainer
    if (!modalContainer) return
    
    if (this.openValue) {
      modalContainer.classList.remove('hidden')
      document.body.style.overflow = 'hidden'
    } else {
      modalContainer.classList.add('hidden')
      document.body.style.overflow = 'auto'
    }
  }
}