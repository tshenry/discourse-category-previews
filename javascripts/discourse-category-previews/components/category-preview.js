import Component from "@ember/component";
import { equal } from "@ember/object/computed";
import discourseComputed from "discourse-common/utils/decorators";

const rawCategoryPreviews = settings.category_previews.split("|");

export default Component.extend({
  noCategoryStyle: equal("siteSettings.category_style", "none"),

  @discourseComputed()
  preview() {
    const previewData = [];
    const loggedInUser = this.currentUser;
    const loggedInUserGroup = loggedInUser ? loggedInUser.groups.map(g => g.name) : [];
    const isStaff = loggedInUser ? loggedInUser.staff : false;
    const categorySlug = this.args.category.slug;

    rawCategoryPreviews.forEach(rawPreview => {
      const previewPart = rawPreview.split("~");
      const permittedGroup = previewPart[4] ? previewPart[4].split(",") : [];
      const hasCategoryAccess = loggedInUserGroup.some(g => permittedGroup.indexOf(g) > -1);
      const shouldRender = !loggedInUser || isStaff || !hasCategoryAccess;

      if (shouldRender && categorySlug === previewPart[0]) {
        previewData.push({
          title: previewPart[1],
          description: previewPart[2],
          href: previewPart[3],
          className: `above-${categorySlug}`,
          color: settings.border_color
        });
      }
    });

    return previewData;
  }
});
