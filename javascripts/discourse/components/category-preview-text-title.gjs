import Component from "@ember/component";
import dIcon from "discourse/helpers/d-icon";

export default class CategoryPreviewTextTitle extends Component {
  <template>
    <div class="category-text-title">
      <span class="category-name">
        <span>
          <span
            class="badge-category__wrapper"
            style="--category-badge-color: #{{this.p.color}};"
          >
            <span
              class="badge-category restricted --style-square"
              title="{{this.p.description}}"
            >
              {{#if settings.locked_icon}}
                {{dIcon settings.locked_icon}}
              {{/if}}
              <span class="badge-category__name">{{this.p.title}}</span>
            </span>
          </span>
        </span>
      </span>
    </div>
  </template>
}
