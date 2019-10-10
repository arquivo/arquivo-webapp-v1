import { h } from '@stencil/core';
import { getIonMode } from '../../global/ionic-global';
import { attachComponent, detachComponent } from '../../utils/framework-delegate';
import { BACKDROP, dismiss, eventMethod, present } from '../../utils/overlays';
import { getClassMap } from '../../utils/theme';
import { deepReady } from '../../utils/transition';
import { iosEnterAnimation } from './animations/ios.enter';
import { iosLeaveAnimation } from './animations/ios.leave';
import { mdEnterAnimation } from './animations/md.enter';
import { mdLeaveAnimation } from './animations/md.leave';
/**
 * @virtualProp {"ios" | "md"} mode - The mode determines which platform styles to use.
 */
export class Popover {
    constructor() {
        this.presented = false;
        this.mode = getIonMode(this);
        /**
         * If `true`, the keyboard will be automatically dismissed when the overlay is presented.
         */
        this.keyboardClose = true;
        /**
         * If `true`, the popover will be dismissed when the backdrop is clicked.
         */
        this.backdropDismiss = true;
        /**
         * If `true`, a backdrop will be displayed behind the popover.
         */
        this.showBackdrop = true;
        /**
         * If `true`, the popover will be translucent.
         */
        this.translucent = false;
        /**
         * If `true`, the popover will animate.
         */
        this.animated = true;
    }
    onDismiss(ev) {
        ev.stopPropagation();
        ev.preventDefault();
        this.dismiss();
    }
    onBackdropTap() {
        this.dismiss(undefined, BACKDROP);
    }
    lifecycle(modalEvent) {
        const el = this.usersElement;
        const name = LIFECYCLE_MAP[modalEvent.type];
        if (el && name) {
            const event = new CustomEvent(name, {
                bubbles: false,
                cancelable: false,
                detail: modalEvent.detail
            });
            el.dispatchEvent(event);
        }
    }
    /**
     * Present the popover overlay after it has been created.
     */
    async present() {
        if (this.presented) {
            return;
        }
        const container = this.el.querySelector('.popover-content');
        if (!container) {
            throw new Error('container is undefined');
        }
        const data = Object.assign({}, this.componentProps, { popover: this.el });
        this.usersElement = await attachComponent(this.delegate, container, this.component, ['popover-viewport', this.el['s-sc']], data);
        await deepReady(this.usersElement);
        return present(this, 'popoverEnter', iosEnterAnimation, mdEnterAnimation, this.event);
    }
    /**
     * Dismiss the popover overlay after it has been presented.
     *
     * @param data Any data to emit in the dismiss events.
     * @param role The role of the element that is dismissing the popover. For example, 'cancel' or 'backdrop'.
     */
    async dismiss(data, role) {
        const shouldDismiss = await dismiss(this, data, role, 'popoverLeave', iosLeaveAnimation, mdLeaveAnimation, this.event);
        if (shouldDismiss) {
            await detachComponent(this.delegate, this.usersElement);
        }
        return shouldDismiss;
    }
    /**
     * Returns a promise that resolves when the popover did dismiss.
     */
    onDidDismiss() {
        return eventMethod(this.el, 'ionPopoverDidDismiss');
    }
    /**
     * Returns a promise that resolves when the popover will dismiss.
     */
    onWillDismiss() {
        return eventMethod(this.el, 'ionPopoverWillDismiss');
    }
    hostData() {
        const mode = getIonMode(this);
        return {
            'aria-modal': 'true',
            'no-router': true,
            style: {
                zIndex: 20000 + this.overlayIndex,
            },
            class: Object.assign({}, getClassMap(this.cssClass), { [mode]: true, 'popover-translucent': this.translucent })
        };
    }
    render() {
        return [
            h("ion-backdrop", { tappable: this.backdropDismiss, visible: this.showBackdrop }),
            h("div", { class: "popover-wrapper" },
                h("div", { class: "popover-arrow" }),
                h("div", { class: "popover-content" }))
        ];
    }
    static get is() { return "ion-popover"; }
    static get encapsulation() { return "scoped"; }
    static get originalStyleUrls() { return {
        "ios": ["popover.ios.scss"],
        "md": ["popover.md.scss"]
    }; }
    static get styleUrls() { return {
        "ios": ["popover.ios.css"],
        "md": ["popover.md.css"]
    }; }
    static get properties() { return {
        "delegate": {
            "type": "unknown",
            "mutable": false,
            "complexType": {
                "original": "FrameworkDelegate",
                "resolved": "FrameworkDelegate | undefined",
                "references": {
                    "FrameworkDelegate": {
                        "location": "import",
                        "path": "../../interface"
                    }
                }
            },
            "required": false,
            "optional": true,
            "docs": {
                "tags": [{
                        "text": undefined,
                        "name": "internal"
                    }],
                "text": ""
            }
        },
        "overlayIndex": {
            "type": "number",
            "mutable": false,
            "complexType": {
                "original": "number",
                "resolved": "number",
                "references": {}
            },
            "required": true,
            "optional": false,
            "docs": {
                "tags": [{
                        "text": undefined,
                        "name": "internal"
                    }],
                "text": ""
            },
            "attribute": "overlay-index",
            "reflect": false
        },
        "enterAnimation": {
            "type": "unknown",
            "mutable": false,
            "complexType": {
                "original": "AnimationBuilder",
                "resolved": "((Animation: Animation, baseEl: any, opts?: any) => Promise<Animation>) | undefined",
                "references": {
                    "AnimationBuilder": {
                        "location": "import",
                        "path": "../../interface"
                    }
                }
            },
            "required": false,
            "optional": true,
            "docs": {
                "tags": [],
                "text": "Animation to use when the popover is presented."
            }
        },
        "leaveAnimation": {
            "type": "unknown",
            "mutable": false,
            "complexType": {
                "original": "AnimationBuilder",
                "resolved": "((Animation: Animation, baseEl: any, opts?: any) => Promise<Animation>) | undefined",
                "references": {
                    "AnimationBuilder": {
                        "location": "import",
                        "path": "../../interface"
                    }
                }
            },
            "required": false,
            "optional": true,
            "docs": {
                "tags": [],
                "text": "Animation to use when the popover is dismissed."
            }
        },
        "component": {
            "type": "string",
            "mutable": false,
            "complexType": {
                "original": "ComponentRef",
                "resolved": "Function | HTMLElement | null | string",
                "references": {
                    "ComponentRef": {
                        "location": "import",
                        "path": "../../interface"
                    }
                }
            },
            "required": true,
            "optional": false,
            "docs": {
                "tags": [],
                "text": "The component to display inside of the popover."
            },
            "attribute": "component",
            "reflect": false
        },
        "componentProps": {
            "type": "unknown",
            "mutable": false,
            "complexType": {
                "original": "ComponentProps",
                "resolved": "undefined | { [key: string]: any; }",
                "references": {
                    "ComponentProps": {
                        "location": "import",
                        "path": "../../interface"
                    }
                }
            },
            "required": false,
            "optional": true,
            "docs": {
                "tags": [],
                "text": "The data to pass to the popover component."
            }
        },
        "keyboardClose": {
            "type": "boolean",
            "mutable": false,
            "complexType": {
                "original": "boolean",
                "resolved": "boolean",
                "references": {}
            },
            "required": false,
            "optional": false,
            "docs": {
                "tags": [],
                "text": "If `true`, the keyboard will be automatically dismissed when the overlay is presented."
            },
            "attribute": "keyboard-close",
            "reflect": false,
            "defaultValue": "true"
        },
        "cssClass": {
            "type": "string",
            "mutable": false,
            "complexType": {
                "original": "string | string[]",
                "resolved": "string | string[] | undefined",
                "references": {}
            },
            "required": false,
            "optional": true,
            "docs": {
                "tags": [],
                "text": "Additional classes to apply for custom CSS. If multiple classes are\nprovided they should be separated by spaces."
            },
            "attribute": "css-class",
            "reflect": false
        },
        "backdropDismiss": {
            "type": "boolean",
            "mutable": false,
            "complexType": {
                "original": "boolean",
                "resolved": "boolean",
                "references": {}
            },
            "required": false,
            "optional": false,
            "docs": {
                "tags": [],
                "text": "If `true`, the popover will be dismissed when the backdrop is clicked."
            },
            "attribute": "backdrop-dismiss",
            "reflect": false,
            "defaultValue": "true"
        },
        "event": {
            "type": "any",
            "mutable": false,
            "complexType": {
                "original": "any",
                "resolved": "any",
                "references": {}
            },
            "required": false,
            "optional": false,
            "docs": {
                "tags": [],
                "text": "The event to pass to the popover animation."
            },
            "attribute": "event",
            "reflect": false
        },
        "showBackdrop": {
            "type": "boolean",
            "mutable": false,
            "complexType": {
                "original": "boolean",
                "resolved": "boolean",
                "references": {}
            },
            "required": false,
            "optional": false,
            "docs": {
                "tags": [],
                "text": "If `true`, a backdrop will be displayed behind the popover."
            },
            "attribute": "show-backdrop",
            "reflect": false,
            "defaultValue": "true"
        },
        "translucent": {
            "type": "boolean",
            "mutable": false,
            "complexType": {
                "original": "boolean",
                "resolved": "boolean",
                "references": {}
            },
            "required": false,
            "optional": false,
            "docs": {
                "tags": [],
                "text": "If `true`, the popover will be translucent."
            },
            "attribute": "translucent",
            "reflect": false,
            "defaultValue": "false"
        },
        "animated": {
            "type": "boolean",
            "mutable": false,
            "complexType": {
                "original": "boolean",
                "resolved": "boolean",
                "references": {}
            },
            "required": false,
            "optional": false,
            "docs": {
                "tags": [],
                "text": "If `true`, the popover will animate."
            },
            "attribute": "animated",
            "reflect": false,
            "defaultValue": "true"
        }
    }; }
    static get events() { return [{
            "method": "didPresent",
            "name": "ionPopoverDidPresent",
            "bubbles": true,
            "cancelable": true,
            "composed": true,
            "docs": {
                "tags": [],
                "text": "Emitted after the popover has presented."
            },
            "complexType": {
                "original": "void",
                "resolved": "void",
                "references": {}
            }
        }, {
            "method": "willPresent",
            "name": "ionPopoverWillPresent",
            "bubbles": true,
            "cancelable": true,
            "composed": true,
            "docs": {
                "tags": [],
                "text": "Emitted before the popover has presented."
            },
            "complexType": {
                "original": "void",
                "resolved": "void",
                "references": {}
            }
        }, {
            "method": "willDismiss",
            "name": "ionPopoverWillDismiss",
            "bubbles": true,
            "cancelable": true,
            "composed": true,
            "docs": {
                "tags": [],
                "text": "Emitted before the popover has dismissed."
            },
            "complexType": {
                "original": "OverlayEventDetail",
                "resolved": "OverlayEventDetail<any>",
                "references": {
                    "OverlayEventDetail": {
                        "location": "import",
                        "path": "../../interface"
                    }
                }
            }
        }, {
            "method": "didDismiss",
            "name": "ionPopoverDidDismiss",
            "bubbles": true,
            "cancelable": true,
            "composed": true,
            "docs": {
                "tags": [],
                "text": "Emitted after the popover has dismissed."
            },
            "complexType": {
                "original": "OverlayEventDetail",
                "resolved": "OverlayEventDetail<any>",
                "references": {
                    "OverlayEventDetail": {
                        "location": "import",
                        "path": "../../interface"
                    }
                }
            }
        }]; }
    static get methods() { return {
        "present": {
            "complexType": {
                "signature": "() => Promise<void>",
                "parameters": [],
                "references": {
                    "Promise": {
                        "location": "global"
                    }
                },
                "return": "Promise<void>"
            },
            "docs": {
                "text": "Present the popover overlay after it has been created.",
                "tags": []
            }
        },
        "dismiss": {
            "complexType": {
                "signature": "(data?: any, role?: string | undefined) => Promise<boolean>",
                "parameters": [{
                        "tags": [{
                                "text": "data Any data to emit in the dismiss events.",
                                "name": "param"
                            }],
                        "text": "Any data to emit in the dismiss events."
                    }, {
                        "tags": [{
                                "text": "role The role of the element that is dismissing the popover. For example, 'cancel' or 'backdrop'.",
                                "name": "param"
                            }],
                        "text": "The role of the element that is dismissing the popover. For example, 'cancel' or 'backdrop'."
                    }],
                "references": {
                    "Promise": {
                        "location": "global"
                    }
                },
                "return": "Promise<boolean>"
            },
            "docs": {
                "text": "Dismiss the popover overlay after it has been presented.",
                "tags": [{
                        "name": "param",
                        "text": "data Any data to emit in the dismiss events."
                    }, {
                        "name": "param",
                        "text": "role The role of the element that is dismissing the popover. For example, 'cancel' or 'backdrop'."
                    }]
            }
        },
        "onDidDismiss": {
            "complexType": {
                "signature": "() => Promise<OverlayEventDetail<any>>",
                "parameters": [],
                "references": {
                    "Promise": {
                        "location": "global"
                    },
                    "OverlayEventDetail": {
                        "location": "import",
                        "path": "../../interface"
                    }
                },
                "return": "Promise<OverlayEventDetail<any>>"
            },
            "docs": {
                "text": "Returns a promise that resolves when the popover did dismiss.",
                "tags": []
            }
        },
        "onWillDismiss": {
            "complexType": {
                "signature": "() => Promise<OverlayEventDetail<any>>",
                "parameters": [],
                "references": {
                    "Promise": {
                        "location": "global"
                    },
                    "OverlayEventDetail": {
                        "location": "import",
                        "path": "../../interface"
                    }
                },
                "return": "Promise<OverlayEventDetail<any>>"
            },
            "docs": {
                "text": "Returns a promise that resolves when the popover will dismiss.",
                "tags": []
            }
        }
    }; }
    static get elementRef() { return "el"; }
    static get listeners() { return [{
            "name": "ionDismiss",
            "method": "onDismiss",
            "target": undefined,
            "capture": false,
            "passive": false
        }, {
            "name": "ionBackdropTap",
            "method": "onBackdropTap",
            "target": undefined,
            "capture": false,
            "passive": false
        }, {
            "name": "ionPopoverDidPresent",
            "method": "lifecycle",
            "target": undefined,
            "capture": false,
            "passive": false
        }, {
            "name": "ionPopoverWillPresent",
            "method": "lifecycle",
            "target": undefined,
            "capture": false,
            "passive": false
        }, {
            "name": "ionPopoverWillDismiss",
            "method": "lifecycle",
            "target": undefined,
            "capture": false,
            "passive": false
        }, {
            "name": "ionPopoverDidDismiss",
            "method": "lifecycle",
            "target": undefined,
            "capture": false,
            "passive": false
        }]; }
}
const LIFECYCLE_MAP = {
    'ionPopoverDidPresent': 'ionViewDidEnter',
    'ionPopoverWillPresent': 'ionViewWillEnter',
    'ionPopoverWillDismiss': 'ionViewWillLeave',
    'ionPopoverDidDismiss': 'ionViewDidLeave',
};
