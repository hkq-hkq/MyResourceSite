// 资源数据类型定义
export interface Resource {
  id: string;
  title: string;
  description: string;
  category: string;
  tags: string[];
  coverImage?: string;
  fileUrl: string;
  fileSize: string;
  platform: string; // 网盘平台：百度网盘、阿里云盘、夸克网盘等
  downloadCount: number;
  author: {
    name: string;
    avatar: string;
  };
  createdAt: string;
  featured: boolean;
}

// 分类数据类型
export interface Category {
  id: string;
  name: string;
  slug: string;
  icon: string;
  color: string;
  count: number;
}

// 分类数据
export const categories: Category[] = [
  { id: '1', name: '设计资源', slug: 'design', icon: 'M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z', color: 'from-pink-500 to-rose-500', count: 45 },
  { id: '2', name: '开发工具', slug: 'dev-tools', icon: 'M10 20l4-16m4 4l4 4-4M6 16l-4-4 4 4', color: 'from-purple-500 to-indigo-500', count: 38 },
  { id: '3', name: '视频教程', slug: 'tutorials', icon: 'M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z', color: 'from-cyan-500 to-blue-500', count: 52 },
  { id: '4', name: '电子书', slug: 'ebooks', icon: 'M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332-.477-4.5-1.253', color: 'from-green-500 to-emerald-500', count: 28 },
  { id: '5', name: '软件素材', slug: 'assets', icon: 'M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10', color: 'from-orange-500 to-amber-500', count: 61 },
  { id: '6', name: '模板源码', slug: 'templates', icon: 'M10 20l4-16m4 4l4 4-4M6 16l-4-4 4 4', color: 'from-red-500 to-pink-500', count: 34 },
];

// 示例资源数据
export const resources: Resource[] = [
  {
    id: '1',
    title: '2024最新UI设计系统Figma文件',
    description: '包含完整的组件库、设计规范、色彩系统、图标库等，支持自定义主题。适合移动端和Web端项目使用。',
    category: '设计资源',
    tags: ['Figma', 'UI设计', '设计系统', '组件库'],
    fileUrl: 'https://pan.baidu.com/s/xxx',
    fileSize: '156 MB',
    platform: '百度网盘',
    downloadCount: 15420,
    author: { name: '设计达人', avatar: '/favicon.svg' },
    createdAt: '2024-01-15',
    featured: true,
  },
  {
    id: '2',
    title: 'React 18全栈开发实战视频教程',
    description: '从零基础到实战项目，包含React 18新特性、Next.js、TypeScript、数据库集成等完整内容。',
    category: '视频教程',
    tags: ['React', '前端开发', '全栈', 'TypeScript'],
    fileUrl: 'https://www.aliyundrive.com/s/xxx',
    fileSize: '8.5 GB',
    platform: '阿里云盘',
    downloadCount: 12350,
    author: { name: '码农小王', avatar: '/favicon.svg' },
    createdAt: '2024-01-12',
    featured: true,
  },
  {
    id: '3',
    title: '3000+精美PPT模板合集',
    description: '商务汇报、产品发布、年度总结、教学课件等多种场景，支持PowerPoint和Keynote格式。',
    category: '设计资源',
    tags: ['PPT', '模板', '商务', '办公'],
    fileUrl: 'https://pan.quark.cn/s/xxx',
    fileSize: '2.3 GB',
    platform: '夸克网盘',
    downloadCount: 28930,
    author: { name: 'PPT大师', avatar: '/favicon.svg' },
    createdAt: '2024-01-10',
    featured: true,
  },
  {
    id: '4',
    title: 'Python数据分析全套工具包',
    description: '包含Jupyter Notebook模板、Pandas/NumPy常用代码片段、可视化库配置等。',
    category: '开发工具',
    tags: ['Python', '数据分析', 'Jupyter', 'Pandas'],
    fileUrl: 'https://pan.baidu.com/s/xxx',
    fileSize: '89 MB',
    platform: '百度网盘',
    downloadCount: 8760,
    author: { name: 'Python学习', avatar: '/favicon.svg' },
    createdAt: '2024-01-08',
    featured: false,
  },
  {
    id: '5',
    title: 'Midjourney AI绘画提示词大全',
    description: '精心整理的10万+条提示词，涵盖人像、风景、建筑、动漫等多种风格，附带使用教程。',
    category: '电子书',
    tags: ['AI绘画', 'Midjourney', '提示词', '教程'],
    fileUrl: 'https://www.aliyundrive.com/s/xxx',
    fileSize: '45 MB',
    platform: '阿里云盘',
    downloadCount: 31200,
    author: { name: 'AI艺术', avatar: '/favicon.svg' },
    createdAt: '2024-01-05',
    featured: true,
  },
  {
    id: '6',
    title: '500+矢量图标素材包SVG',
    description: '线性、填充、双色等多种风格，支持AI、Figma、Sketch等设计软件直接编辑。',
    category: '软件素材',
    tags: ['图标', 'SVG', '矢量', 'UI素材'],
    fileUrl: 'https://pan.quark.cn/s/xxx',
    fileSize: '128 MB',
    platform: '夸克网盘',
    downloadCount: 19560,
    author: { name: '图标库', avatar: '/favicon.svg' },
    createdAt: '2024-01-03',
    featured: false,
  },
  {
    id: '7',
    title: 'Vue3+Vite企业级后台管理系统源码',
    description: '完整权限管理、动态路由、国际化、主题切换等功能，开箱即用。',
    category: '模板源码',
    tags: ['Vue3', 'Vite', '后台管理', 'TypeScript'],
    fileUrl: 'https://github.com/xxx',
    fileSize: '源码仓库',
    platform: 'GitHub',
    downloadCount: 22100,
    author: { name: '前端老兵', avatar: '/favicon.svg' },
    createdAt: '2024-01-01',
    featured: false,
  },
  {
    id: '8',
    title: 'Pr/Ae视频剪辑特效预设包',
    description: '包含转场、调色、字幕动画、特效合成等500+个预设文件，大幅提升剪辑效率。',
    category: '软件素材',
    tags: ['Pr', 'Ae', '视频剪辑', '特效预设'],
    fileUrl: 'https://pan.baidu.com/s/xxx',
    fileSize: '1.8 GB',
    platform: '百度网盘',
    downloadCount: 17890,
    author: { name: '剪辑师小李', avatar: '/favicon.svg' },
    createdAt: '2023-12-28',
    featured: false,
  },
];

// 获取所有资源
export function getAllResources(): Resource[] {
  return resources;
}

// 获取精选资源
export function getFeaturedResources(): Resource[] {
  return resources.filter(r => r.featured);
}

// 根据分类获取资源
export function getResourcesByCategory(category: string): Resource[] {
  return resources.filter(r => r.category === category);
}

// 根据ID获取单个资源
export function getResourceById(id: string): Resource | undefined {
  return resources.find(r => r.id === id);
}

// 获取所有标签
export function getAllTags(): string[] {
  const tags = new Set<string>();
  resources.forEach(r => {
    r.tags.forEach(tag => tags.add(tag));
  });
  return Array.from(tags).sort();
}

// 搜索资源
export function searchResources(query: string): Resource[] {
  const lowerQuery = query.toLowerCase();
  return resources.filter(r =>
    r.title.toLowerCase().includes(lowerQuery) ||
    r.description.toLowerCase().includes(lowerQuery) ||
    r.tags.some(tag => tag.toLowerCase().includes(lowerQuery))
  );
}
