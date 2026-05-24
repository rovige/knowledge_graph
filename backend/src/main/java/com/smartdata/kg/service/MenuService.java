package com.smartdata.kg.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartdata.kg.common.PageResult;
import com.smartdata.kg.entity.Menu;
import com.smartdata.kg.repository.MenuRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MenuService extends ServiceImpl<MenuRepository, Menu> {

    public List<Menu> tree() {
        List<Menu> allMenus = list(new LambdaQueryWrapper<Menu>()
                .eq(Menu::getVisible, 1)
                .orderByAsc(Menu::getSort));
        
        return buildTree(allMenus, 0L);
    }

    public List<Menu> listAll() {
        return list(new LambdaQueryWrapper<Menu>()
                .orderByAsc(Menu::getSort));
    }

    public PageResult<Menu> page(Integer current, Integer size, String keyword) {
        Page<Menu> page = new Page<>(current, size);
        LambdaQueryWrapper<Menu> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Menu::getName, keyword)
                    .or()
                    .like(Menu::getPath, keyword);
        }
        wrapper.orderByAsc(Menu::getSort);
        page(page, wrapper);
        return new PageResult<>(page.getTotal(), page.getRecords());
    }

    private List<Menu> buildTree(List<Menu> menus, Long parentId) {
        List<Menu> tree = new ArrayList<>();
        for (Menu menu : menus) {
            if (parentId.equals(menu.getParentId())) {
                menu.setChildren(buildTree(menus, menu.getId()));
                tree.add(menu);
            }
        }
        return tree;
    }

    public Menu getById(Long id) {
        return getOne(new LambdaQueryWrapper<Menu>()
                .eq(Menu::getId, id));
    }
}
