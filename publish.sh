#!/bin/bash

# ESLint Config 包发布脚本
# 
# 这个脚本会帮助你发布所有的 ESLint 配置包到 npm

echo "🚀 准备发布 ESLint Config 包到 npm"
echo "================================="

# 1. 检查 npm 登录状态
echo "📋 步骤 1: 检查 npm 登录状态"
if ! npm whoami > /dev/null 2>&1; then
    echo "❌ 未登录到 npm，请先登录："
    echo "   npm login"
    echo ""
    echo "登录后再次运行此脚本"
    exit 1
fi

echo "✅ 已登录到 npm，当前用户: $(npm whoami)"

# 2. 运行测试确保配置正确
echo ""
echo "📋 步骤 2: 运行测试"
echo "检查所有配置是否正常工作..."

# 创建临时测试脚本
cat > test-before-publish.js << 'EOF'
const configs = [
  './packages/basic/index.js',
  './packages/typescript/index.js', 
  './packages/react/index.js',
  './packages/vue/index.js',
  './packages/all/index.js'
]

let allPassed = true

configs.forEach(configPath => {
  try {
    const config = require(configPath)
    if (!Array.isArray(config)) {
      throw new Error('配置必须是数组格式')
    }
    console.log(`✅ ${configPath.replace('./packages/', '').replace('/index.js', '')} 配置加载成功`)
  } catch (error) {
    console.log(`❌ ${configPath.replace('./packages/', '').replace('/index.js', '')} 配置加载失败: ${error.message}`)
    allPassed = false
  }
})

if (!allPassed) {
  console.log('\n❌ 测试失败，请修复配置后再发布')
  process.exit(1)
} else {
  console.log('\n✅ 所有配置测试通过')
}
EOF

node test-before-publish.js
rm test-before-publish.js

if [ $? -ne 0 ]; then
    echo "❌ 测试失败，请修复后再发布"
    exit 1
fi

# 3. 显示即将发布的包
echo ""
echo "📋 步骤 3: 即将发布的包"
echo "======================="

packages=(
    "packages/basic:@mengjx/eslint-config-basic"
    "packages/typescript:@mengjx/eslint-config-ts" 
    "packages/react:@mengjx/eslint-config-react"
    "packages/vue:@mengjx/eslint-config-vue"
    "packages/all:@mengjx/eslint-config"
)

for package in "${packages[@]}"; do
    dir=$(echo $package | cut -d: -f1)
    name=$(echo $package | cut -d: -f2)
    version=$(node -p "require('./$dir/package.json').version")
    echo "📦 $name@$version"
done

# 4. 确认发布
echo ""
echo "📋 步骤 4: 确认发布"
echo "=================="
read -p "确认要发布以上包吗？(y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 取消发布"
    exit 1
fi

# 5. 使用 bumpp 升级版本并发布
echo ""
echo "📋 步骤 5: 升级版本并发布"
echo "========================"

echo "选择版本升级类型:"
echo "1) patch (0.0.1 -> 0.0.2) - bug修复"
echo "2) minor (0.0.1 -> 0.1.0) - 新功能"  
echo "3) major (0.0.1 -> 1.0.0) - 破坏性变更"
echo "4) custom - 自定义版本"

read -p "请选择 (1-4): " choice

case $choice in
    1)
        echo "🔄 执行 patch 版本升级并发布..."
        pnpm bumpp package.json packages/*/package.json --commit --push --tag
        ;;
    2)
        echo "🔄 执行 minor 版本升级并发布..."
        pnpm bumpp minor package.json packages/*/package.json --commit --push --tag
        ;;
    3)
        echo "🔄 执行 major 版本升级并发布..."
        pnpm bumpp major package.json packages/*/package.json --commit --push --tag
        ;;
    4)
        read -p "请输入新版本号 (例如: 1.0.0): " version
        echo "🔄 执行自定义版本升级并发布..."
        pnpm bumpp $version package.json packages/*/package.json --commit --push --tag
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

if [ $? -ne 0 ]; then
    echo "❌ 版本升级失败"
    exit 1
fi

# 6. 发布到 npm
echo ""
echo "📋 步骤 6: 发布到 npm"
echo "==================="

echo "🚀 开始发布包..."
pnpm -r publish --access public

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 发布成功！"
    echo "============"
    echo ""
    echo "包已成功发布到 npm："
    for package in "${packages[@]}"; do
        name=$(echo $package | cut -d: -f2)
        echo "📦 https://www.npmjs.com/package/$name"
    done
    echo ""
    echo "📖 使用方法："
    echo "npm install -D eslint $name"
    echo ""
else
    echo "❌ 发布失败，请检查错误信息"
    exit 1
fi