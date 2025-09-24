import { apiInitializer } from "discourse/lib/api";
import CategoryPreview from "../components/category-preview";

export default apiInitializer((api) => {
  api.renderInOutlet("category-box-before-each-box", CategoryPreview);
  api.renderInOutlet("category-list-above-each-category", CategoryPreview);
});
