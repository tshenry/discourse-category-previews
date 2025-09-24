import Component from "@glimmer/component";
import { computed } from "@ember/object";
import { equal } from "@ember/object/computed";
import { service } from "@ember/service";
import borderColor from "discourse/helpers/border-color";
import htmlSafe from "discourse/helpers/html-safe";
import CategoryPreviewTextTitle from "./category-preview-text-title";

export default class CategoryPreview extends Component {
  @service siteSettings;
  @service site;

  @equal("siteSettings.category_style", "none") noCategoryStyle;

  @computed()
  get isBoxStyle() {
    return (
      this.siteSettings.desktop_category_page_style === "categories_boxes" ||
      this.siteSettings.mobile_category_page_style === "categories_boxes"
    );
  }

  @computed()
  get preview() {
    const previewData = [];
    const rawCategoryPreviews = settings.category_previews.split("|");
    const loggedInUser = this.currentUser;
    const loggedInUserGroup = loggedInUser
      ? loggedInUser.groups.map((g) => g.name)
      : [];
    const isStaff = loggedInUser ? loggedInUser.staff : false;
    const categorySlug = this.args.category.slug;

    rawCategoryPreviews.forEach((rawPreview) => {
      const previewPart = rawPreview.split("~");
      const permittedGroup = previewPart[4] ? previewPart[4].split(",") : [];
      const hasCategoryAccess = loggedInUserGroup.some(
        (g) => permittedGroup.indexOf(g) > -1
      );
      const shouldRender = !loggedInUser || isStaff || !hasCategoryAccess;

      if (shouldRender && categorySlug === previewPart[0]) {
        previewData.push({
          title: previewPart[1],
          description: previewPart[2],
          href: previewPart[3],
          className: `above-${categorySlug}`,
          color: settings.border_color,
        });
      }
    });

    return previewData;
  }

  <template>
    {{#if this.preview}}
      {{#each this.preview as |p|}}
        {{#if this.isBoxStyle}}
          <div
            style={{unless this.noCategoryStyle (borderColor p.color)}}
            class="category category-box
              {{if this.noCategoryStyle 'no-category-boxes-style'}}
              {{p.className}}"
          >
            <div class="category-box-inner">
              <div class="category-logo">
              </div>
              <div class="category-details">
                <div class="category-box-heading">
                  {{#if p.href}}
                    <a class="parent-box-link" href={{p.href}}>
                      <h3>
                        <CategoryPreviewTextTitle @p={{p}} />
                      </h3>
                    </a>
                  {{else}}
                    <h3>
                      <CategoryPreviewTextTitle @p={{p}} />
                    </h3>
                  {{/if}}
                </div>
                {{#if p.description}}
                  <div class="description">
                    {{htmlSafe p.description}}
                  </div>
                {{/if}}
              </div>
            </div>
          </div>
        {{else if this.site.mobileView}}
          <div
            style={{borderColor p.color}}
            class="category-list-item category {{p.className}}"
          >
            <table class="topic-list">
              <tbody>
                <tr>
                  <th class="main-link">
                    <h3>
                      {{#if p.href}}
                        <a class="category-title-link" href={{p.href}}>
                          <CategoryPreviewTextTitle @p={{p}} />
                        </a>
                      {{else}}
                        <CategoryPreviewTextTitle @p={{p}} />
                      {{/if}}
                    </h3>
                  </th>
                </tr>
                <tr class="category-description">
                  <td colspan="3">
                    {{#if p.description}}
                      <div class="category-description">{{htmlSafe
                          p.description
                        }}</div>
                    {{/if}}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        {{else}}
          <tr class={{p.className}}>
            <td
              colspan="2"
              class="category {{if this.noCategoryStyle 'no-category-style'}}"
              style={{unless this.noCategoryStyle (borderColor p.color)}}
            >
              <h3>
                {{#if p.href}}
                  <a class="category-title-link" href={{p.href}}>
                    <CategoryPreviewTextTitle @p={{p}} />
                  </a>
                {{else}}
                  <CategoryPreviewTextTitle @p={{p}} />
                {{/if}}
              </h3>
              {{#if p.description}}
                <div class="category-description">{{htmlSafe
                    p.description
                  }}</div>
              {{/if}}
            </td>
          </tr>
        {{/if}}
      {{/each}}
    {{/if}}
  </template>
}
